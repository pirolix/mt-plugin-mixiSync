package MT::Plugin::OMV::mixiSync;
use strict;
#   mixiSync - Easy way of the duplicated post from MovableType entry into mixi diary.
#           Original Copyright (c) 2006-2008 Piroli YUKARINOMIYA (MagicVox)
#           Open MagicVox.net - http://www.magicvox.net/
#           @see http://www.magicvox.net/archive/2006/02041724

#   This code is released under the Artistic License.
#   The terms of the Artistic License are described at
#   http://www.perl.com/language/misc/Artistic.html

use MT;
use MT::PluginData;# tenu
use MT::Author;
use MT::Blog;
use MT::Entry;
use MT::Util;

use vars qw( $MYNAME $VERSION );
$MYNAME = 'mixiSync';
$VERSION = '2.01';

use base qw( MT::Plugin );
my $plugin = new MT::Plugin({
        name => $MYNAME,
        version => $VERSION,
        author_name => 'Piroli YUKARINOMIYA',
        author_link => 'http://mixi.jp/show_friend.pl?id=124745',
        doc_link => 'http://www.magicvox.net/archive/2006/02041724/',
        description => <<HTMLHEREDOC,
Easy way of the duplicated post from MovableType entry into <a href="http://mixi.jp/list_diary.pl">mixi diary</a>.<br />
<br />
At first, make sure to setup the mixi user IDs onto each <a href="?__mode=list_authors">Authors</a>.
mixi user ID of yours would be found in <a href="http://mixi.jp/show_profile.pl">mixi profile page</a>.
HTMLHEREDOC
});
MT->add_plugin( $plugin );

sub instance { $plugin }



;# if module template of specified name exists, mixiSync use its content to format
my $template_name = 'mixiSync Entry Template';



### Customize the entry editing page of MovableType
MT->add_callback( 'MT::App::CMS::template_source.edit_entry', 9, $plugin, \&add_mixi_sync );
sub add_mixi_sync {
    my( $cb, $app, $template ) = @_;

    if( add_mixi_sync_hidden_form( $cb, $app, $template )) {
        add_mixi_sync_button( $cb, $app, $template );
        return 1;
    }

    # Error; mixiSync isn't initialized yet.
    my $old = quotemeta( <<HTML );
    <mt:if name="saved_deleted_ping">
HTML
    my $add = <<HTML;
        <mtapp:statusmsg
            id="mixisync-init-error"
            class="error">
$MYNAME: <MT_TRANS phrase="Invalid author_id">
<a href="?__mode=view&amp;_type=author&amp;id=<TMPL_VAR NAME=AUTHOR_ID>"><MT_TRANS phrase="Plugins"><MT_TRANS phrase="unassigned"></a>
        </mtapp:statusmsg>
HTML
    $$template =~ s/($old)/$add$1/;
}

### Add hidden form for mixi diary
sub add_mixi_sync_hidden_form {
    my( $cb, $app, $template ) = @_;
    my $author_id = $app->{author}->id
        or return undef;

    my $mixi_user_id;
    my $mixi_premium;
    &GetPluginData( $author_id, \$mixi_user_id, \$mixi_premium );
    $mixi_user_id
        or return undef;

    my $old = quotemeta( <<HTML );
<mt:include name="include/footer.tmpl" id="footer_include">
HTML
    my $add = <<HTML;
<form id="mixi_diary" name="mixi_diary" target="mixi_diary"
        method="post" action="http://mixi.jp/add_diary.pl" accept-charset="EUC-JP">
<input type="hidden" name="news_id" value="" />
<input type="hidden" name="campaign_id" value="" />
<input type="hidden" name="invite_campaign" value="" />
<input type="hidden" name="id" value="$mixi_user_id" />
<input type="hidden" name="news_title" value="" />
<input type="hidden" name="news_url" value="" />
<input type="hidden" name="movie_id" value="" />
<input type="hidden" name="movie_title" value="" />
<input type="hidden" name="movie_url" value="" />
<input type="hidden" name="diary_title" value="" />
<input type="hidden" name="diary_body" value="" />
<input type="hidden" name="dummy_eucjp" value="" /><!--dummy field-->
<input type="hidden" name="tag_id" value="4" /><!-- ‘S‘Ì‚ÉŒöŠJ -->
</form>
<!--MIXISYNC_JAVASCRIPT_HERE-->
HTML
    $$template =~ s/($old)/$1$add/;
}

### Add button for mixiSync
sub add_mixi_sync_button {
    my( $cb, $app, $template ) = @_;

    my $old = quotemeta( <<'HTML' );
        ><__trans phrase="Delete"></button>
    </mt:if>
HTML
    my $add = <<HTML;
<input type="button" onclick="invoke_mixiSync();" value="mixi <MT_TRANS phrase="Submit">" />
HTML
    $$template =~ s/($old)/$1$add/;	
}



### Add JavaScript codes
MT->add_callback( 'MT::App::CMS::template_output.edit_entry', 9, $plugin, \&add_mixi_sync_javascript );
sub add_mixi_sync_javascript {
    my( $cb, $app, $template ) = @_;
    my $q = $app->{query}
        or return undef;
    my $author_id = $app->{author}->id
        or return undef;
    my $blog_id = $q->param('blog_id')
        or return undef;# invalid blog_id

    # MTBlog*
    my $blog = MT::Blog->load( $blog_id );
    my $blog_url = $blog->site_url;
    my $blog_name = MT::Util::encode_js( $blog->name );

    # MTEntryPermalink
    my $entry_permalink;
    if( $q->param( 'id' ) && ( my $entry = MT::Entry->load({
                    blog_id => $blog_id, id => $q->param( 'id' ), status => MT::Entry::RELEASE()})))
    {
        $entry_permalink = $entry->permalink( undef );# preview with current editing entry
    } else {
        $entry_permalink = $blog_url;
    }

    # User customized template
    require MT::Template;
    my $template_js;
    my $tmpl = MT::Template->load({ blog_id => $blog_id, name => $template_name });
    if( $tmpl ) {
        $template_js = $tmpl->text;
    } else {
        $template_js = <<HEREDOC_JS;
    diary_title : '<MTEntryTitle>',
    diary_body : '<MTEntryBody>',
HEREDOC_JS
    }

    # premium user
    my $premium_user = 0;
    my $mixi_user_id;
    &GetPluginData( $author_id, \$mixi_user_id, \$premium_user );

    # Sanitize HTML tags
    my @tags;
    # <br>,<p>
    push @tags, { '<(?:br|p)[^>]*\\/?>[\\n\\r]?' => '\\n' };
    # <hr>
    push @tags, { '<hr[^>]*\\/?>[\\n\\r]?' => ( '-' x 40 ). '\\n' };
    if( $premium_user ) {
        # erase other tags except <a>,<b>
        push @tags, { '<(?!\\/?(?:a|strong|em|u|blockquote|del)\\W)[^>]*\\/?>' => '' };
    } else {
        # save hyperlink
        push @tags, { '<a[^>]*href=["\']([^"\']+)["\'][^>]*>(.*)<\/a>' => '$2( $1 )' };
        # erase other tags
        push @tags, { '<\\/?[^>]*\\/?>' => '' };
    }
    my $sanitize_js;
    foreach my $tag ( @tags ) { foreach( keys %$tag ) {
        $sanitize_js .= sprintf "\t\tval = val.replace(/%s/ig, \"%s\");\n", $_, $tag->{$_};
    } }
    my $old = quotemeta( <<HTML );
<!--MIXISYNC_JAVASCRIPT_HERE-->
HTML
    my $add = <<HTML;
<script type="text/javascript">
var template = {
$template_js
	dummy_eucjp : '&#xFDFE;'
};

function E (id) { return document.getElementById (id) }
function invoke_mixiSync () {
    app.autoSave(); // Retrieve the form item content
	for (i in template) {
		var val = template[i];
		var e;
		(e = E('title')) && (val = val.replace (/<\\\$?MTEntryTitle\\\$?>/ig, e.value));
		(e = E('editor-input-content')) && (val = val.replace (/<\\\$?MTEntryBody\\\$?>/ig, e.value));
		(e = E('editor-input-extended')) && (val = val.replace (/<\\\$?MTEntryMore\\\$?>/ig, e.value));
		(e = E('excerpt')) && (val = val.replace (/<\\\$?MTEntryExcerpt\\\$?>/ig, e.value));
		(e = E('keywords')) && (val = val.replace (/<\\\$?MTEntryKeywords\\\$?>/ig, e.value));
		val = val.replace(/<\\\$?MTBlogURL\\\$?>/ig, '$blog_url');
		val = val.replace(/<\\\$?MTBlogName\\\$?>/ig, '$blog_name');
		val = val.replace(/<\\\$?MTEntryPermalink\\\$?>/ig, '$entry_permalink');
$sanitize_js
        eval( 'document.mixi_diary.' + i + '.value = val;' );
	}

	if (document.charset) {
		var org = document.charset;
		document.charset = 'euc-jp';
		document.mixi_diary.submit();
		document.charset = org;
	} else {
		document.mixi_diary.submit();
	}
}
</script>
HTML
	$$template =~ s/$old/$add/;
}



### Customize the author editing page of MovableType
MT->add_callback ('MT::App::CMS::template_source.edit_author', 9, $plugin, \&add_mixi_sync_edit_author);
sub add_mixi_sync_edit_author {
    my( $cb, $app, $template ) = @_;
    my $author_id = $app->{author}->id
        or return undef;
;#
    my $mixi_user_id;
    my $mixi_premium;
    &GetPluginData( $author_id, \$mixi_user_id, \$mixi_premium );

    # MT4.25
    my $old = quotemeta( <<HTML );
<mt:if name="id">
    <mt:if name="can_use_userpic">
    <mtapp:setting
        id="userpic_asset_id"
HTML
    if ($$template !~ /$old/) {
        # < MT4.21
        $old = quotemeta( <<HTML );
<mt:if name="id">
    <mtapp:setting
        id="userpic_asset_id"
HTML
    }
    my $mixi_premium_checked = $mixi_premium ? ' checked="checked"' : '';
    my $add = <<HTML;
    <mtapp:setting
        id="mixisync"
        label="mixi user ID"
        hint="Input mixi user ID, which can be found in mixi's profile page.">
        <div class="textarea-wrapper">
            <input name="mixi_user_id" id="mixi_user_id" class="full-width" value="$mixi_user_id" /><br />
        </div>
        <input type="checkbox" name="mixi_premium" id="mixi_premium" value="1"$mixi_premium_checked />
        Yes, I&apos;m a mixi Premium user.
    </mtapp:setting>
HTML
    $$template =~ s/($old)/$add$1/;
}

### Store mixi user setting into MT::PluginData
MT::Author->add_callback( 'pre_save', 9, $plugin, \&mixi_sync_author_presave );
sub mixi_sync_author_presave {
    my( $cb, $obj ) = @_;
    my $q = MT->instance->{query}
        or return undef;
    my $author_id = $obj->id
        or return undef;

    my $plugindataobj = MT::PluginData->load({
            plugin => $MYNAME, key => 'author_id::'. $author_id });
    unless( $plugindataobj ) {
        $plugindataobj = MT::PluginData->new
            or return $cb->error( $MYNAME. ': failed to initialize MT::PluginData' );
        $plugindataobj->plugin( $MYNAME );
        $plugindataobj->key( 'author_id::'. $author_id );
    }
    my $plugindata = {};
    $plugindata->{mixi_user_id} = $q->param( 'mixi_user_id' ) || 0;
    $plugindata->{mixi_premium} = $q->param( 'mixi_premium' ) || 0;
    $plugindataobj->data( $plugindata );
    $plugindataobj->save
        or return $cb->error( $plugindataobj->errstr );
}



### Retrieve the each use settings
sub GetPluginData {
    my( $author_id, $mixi_user_id, $mixi_premium ) = @_;

    $$mixi_user_id = undef;
    $$mixi_premium = undef;
    if( my $plugindataobj = MT::PluginData->load({
            plugin => $MYNAME, key => 'author_id::'. $author_id }))
    {
        if( my $plugindata = $plugindataobj->data ) {
            $$mixi_user_id = $plugindata->{mixi_user_id};
            $$mixi_premium = $plugindata->{mixi_premium};
        }
    }
}

1;