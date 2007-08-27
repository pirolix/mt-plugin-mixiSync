package MT::Plugin::mixiSync;
use strict;
;#	mixiSync plugin for MovableType w/ BigPAPI
;#			Original Copyright (c) 2006 Piroli YUKARINOMIYA
;#			Open MagicVox.net - http://www.magicvox.net/
;#			@see http://www.magicvox.net/archive/2006/02041724.php

;#	This code is released under the Artistic License.
;#	The terms of the Artistic License are described at
;#	http://www.perl.com/language/misc/Artistic.html

use MT;
use MT::PluginData;# tenu

use vars qw( $MYNAME $VERSION );
$MYNAME = 'mixiSync';
$VERSION = '1.41';

use base qw( MT::Plugin );
my $plugin = new MT::Plugin ({
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
MT->add_plugin ($plugin);

sub instance { $plugin }



;# if module template of specified name exists, mixiSync use its content to format
my $template_name = 'mixiSync Entry Template';



sub GetPluginData {
	my ($author_id, $mixi_user_id, $mixi_premium) = @_;
;#
	$$mixi_user_id = undef;
	$$mixi_premium = undef;
	if (my $plugindataobj = MT::PluginData->load ({
			plugin => $MYNAME,
			key => 'author_id::'. $author_id }))
	{
		if (my $plugindata = $plugindataobj->data) {
			$$mixi_user_id = $plugindata->{mixi_user_id};
			$$mixi_premium = $plugindata->{mixi_premium};
		}
	}
}


;### Customize the entry editing page of MovableType
MT->add_callback ('bigpapi::template::edit_entry', 9, $plugin, \&add_mixi_sync);
MT->add_callback ('MT::App::CMS::AppTemplateSource.edit_entry', 9, $plugin, \&add_mixi_sync);
MT->add_callback ('MT::App::CMS::AppTemplateSource.entry_actions', 9, $plugin, \&add_mixi_sync_button);
sub add_mixi_sync {
	my ($cb, $app, $template) = @_;
;#
	if (add_mixi_sync_hidden_form ($cb, $app, $template)) {
		add_mixi_sync_javascript ($cb, $app, $template);
		add_mixi_sync_button ($cb, $app, $template);
		return;
	}

	# Error; mixiSync isn't initialized yet.
	my $old = <<HTML;
<TMPL_IF NAME=SAVED_DELETED_PING>
HTML
	my $add = <<HTML;
<div class="error-message">
$MYNAME: <MT_TRANS phrase="Invalid author_id">
<a href="?__mode=view&amp;_type=author&amp;id=<TMPL_VAR NAME=AUTHOR_ID>"><MT_TRANS phrase="Plugins"><MT_TRANS phrase="unassigned"></a>
</div>
HTML
	$old = quotemeta ($old);
	$$template =~ s/($old)/$add$1/;
}

;### Add hidden form for mixi diary
sub add_mixi_sync_hidden_form {
	my ($cb, $app, $template) = @_;
	my $author_id = $app->{author}->id
		or return undef;
;#
	my $mixi_user_id;
	my $mixi_premium;
	&GetPluginData ($author_id, \$mixi_user_id, \$mixi_premium);
	$mixi_user_id
		or return undef;

	my $old = <<HTML;
<TMPL_INCLUDE NAME="footer.tmpl">
HTML
	my $add = <<HTML;
<form id="mixi_diary" name="mixi_diary" target="mixi_diary"
		method="post" action="http://mixi.jp/add_diary.pl" accept-charset="EUC-JP">
<input type="hidden" name="news_id" value="" />
<input type="hidden" name="id" value="$mixi_user_id" />
<input type="hidden" name="dummy_eucjp" value="" />
<input type="hidden" name="diary_title" value="" />
<input type="hidden" name="diary_body" value="" />
</form>	
HTML
	$old = quotemeta ($old);
	$$template =~ s/($old)/$add$1/;
	return 1;
}

;### Add JavaScript codes
sub add_mixi_sync_javascript {
	my ($cb, $app, $template) = @_;
	my $q = $app->{'query'};
	my $author_id = $app->{author}->id
		or return undef;
;#
	$q && $q->param('blog_id')
		or return undef;# invalid blog_id

	;# MTBlog*
    use MT::Blog;
    my $blog = MT::Blog->load ($q->param ('blog_id'));
    my $blog_url = $blog->site_url;
	use MT::Util;
    my $blog_name = MT::Util::encode_js ($blog->name);

	;# MTEntryPermalink
	my $entry_permalink;
	use MT::Entry;
	if ($q->param('id') && (my $entry = MT::Entry->load ({
					'blog_id' => $q->param ('blog_id'), 'id' => $q->param ('id'), status => 2
			}))) {
		$entry_permalink = $entry->permalink (undef);# preview with current editing entry
	} else {
		$entry_permalink = $blog_url;
	}

	;# User customized template
	require MT::Template;
	my $template_js;
	my $tmpl = MT::Template->load({ blog_id => $q->param ('blog_id'), name => $template_name });
	if ($tmpl) {
		$template_js = $tmpl->text;
	} else {
		$template_js = <<HEREDOC_JS;
	diary_title : '<MTEntryTitle>',
	diary_body : '<MTEntryBody>',
HEREDOC_JS
	}

	;# premium user
	my $premium_user = 0;
	my $mixi_user_id;
	&GetPluginData ($author_id, \$mixi_user_id, \$premium_user);

	;# Sanitize HTML tags
	my @tags;
	;# <br>,<p>
	push @tags, { '<(?:br|p)[^>]*\\/?>[\\n\\r]?' => '\\n' };
	;# <hr>
	push @tags, { '<hr[^>]*\\/?>[\\n\\r]?' => ('-' x 40). '\\n' };
	if ($premium_user) {
		;# erase other tags except <a>,<b>
		push @tags, { '<(?!\\/?(?:a|strong|em|u|blockquote|del)\\W)[^>]*\\/?>' => '' };
	} else {
		;# save hyperlink
		push @tags, { '<a[^>]*href=["\']([^"\']+)["\'][^>]*>(.*)<\/a>' => '$2( $1 )' };
		;# erase other tags
		push @tags, { '<\\/?[^>]*\\/?>' => '' };
	}
	my $sanitize_js;
	foreach my $tag (@tags) { foreach (keys %$tag) {
		$sanitize_js .= sprintf "\t\tval = val.replace(/%s/ig, \"%s\");\n", $_, $tag->{$_};
	} }

	my $old = <<HTML;
<TMPL_INCLUDE NAME="header.tmpl">
HTML
	my $add = <<HTML;
<script type="text/javascript">
var template = {
$template_js
	dummy_eucjp : '&#xFDFE;'
};

function E (id) { return document.getElementById (id) }
function invoke_mixiSync () {
	for (i in template) {
		var val = template[i];
		var e;
		(e = E('title')) && (val = val.replace (/<\\\$?MTEntryTitle\\\$?>/ig, e.value));
		(e = E('text')) && (val = val.replace (/<\\\$?MTEntryBody\\\$?>/ig, e.value));
		(e = E('text_more')) && (val = val.replace (/<\\\$?MTEntryMore\\\$?>/ig, e.value));
		(e = E('excerpt')) && (val = val.replace (/<\\\$?MTEntryExcerpt\\\$?>/ig, e.value));
		(e = E('keywords')) && (val = val.replace (/<\\\$?MTEntryKeywords\\\$?>/ig, e.value));
		val = val.replace(/<\\\$?MTBlogURL\\\$?>/ig, '$blog_url');
		val = val.replace(/<\\\$?MTBlogName\\\$?>/ig, '$blog_name');
		val = val.replace(/<\\\$?MTEntryPermalink\\\$?>/ig, '$entry_permalink');
$sanitize_js
		eval ('document.mixi_diary.' + i + '.value = val;');
	}

	if (document.charset) {
		var org = document.charset;
		document.charset = 'euc-jp';
		document.mixi_diary.submit ();
		document.charset = org;
	} else {
		document.mixi_diary.submit ();
	}
}
</script>
HTML
	$old = quotemeta ($old);
	$$template =~ s/($old)/$1$add/;	
}

;### Add button for mixiSync
sub add_mixi_sync_button {
	my ($cb, $app, $template) = @_;
;#
	### for 3.2
	my $old = <<HTML;
<input accesskey="s" type="button" value="<MT_TRANS phrase="Save">" title="<MT_TRANS phrase="Save this entry (s)">" onclick="submitForm(this.form, 'save_entry')" />
HTML
	### for 3.3
	$old = <<HTML if 3.3 <= $MT::VERSION;
<input accesskey="s" type="button" value="<MT_TRANS phrase="Save">" title="<MT_TRANS phrase="Save this entry (s)">" onclick="clearDirty(); submitForm(this.form, 'save_entry'); return true" />
HTML
    ### Additional
	my $add = <<HTML;
<input type="button" value="mixi <MT_TRANS phrase="New Entry Defaults">" title="mixi <MT_TRANS phrase="New Entry Defaults">" onclick="invoke_mixiSync ();" />
HTML
	$old = quotemeta ($old);
	$$template =~ s/($old)/$1$add/;	
}



;### Customize the author editing page of MovableType
MT->add_callback ('bigpapi::template::edit_author', 9, $plugin, \&add_mixi_sync_edit_author);
MT->add_callback ('MT::App::CMS::AppTemplateSource.edit_author', 9, $plugin, \&add_mixi_sync_edit_author);
sub add_mixi_sync_edit_author {
	my ($cb, $app, $template) = @_;
	my $author_id = $app->{author}->id
		or return undef;
;#
	my $mixi_user_id;
	my $mixi_premium;
	&GetPluginData ($author_id, \$mixi_user_id, \$mixi_premium);

	my $old = <<HTML;
<div class="setting">
    <div class="label">
        <label for="preferred_language"><MT_TRANS phrase="Language:"></label>
HTML
	my $mixi_premium_checked = $mixi_premium ? ' checked' : '';
	my $add = <<HTML;
<div class="setting">
    <div class="label">
        <label for="mixi_user_id">mixi user ID:</label>
    </div>
    <div class="field">
        <input name="mixi_user_id" id="mixi_user_id" value="$mixi_user_id" />
        <p>Input mixi user ID, which can be found in <a href="http://mixi.jp/show_profile.pl">mixi profile page</a>.</p>
        <input type="checkbox" name="mixi_premium" id="mixi_premium" value="1"$mixi_premium_checked />
        Yes, I&apos;m a mixi Premium user.
    </div>
</div>

HTML
	$old = quotemeta ($old);
	$$template =~ s/($old)/$add$1/;
}

;### Store mixi user setting into MT::PluginData
use MT::Author;
MT::Author->add_callback ('pre_save', 9, $plugin, \&mixi_sync_author_presave);
sub mixi_sync_author_presave {
	my ($cb, $obj) = @_;
	my $q = MT->instance->{query}
		or return undef;
	my $author_id = $obj->id
		or return undef;
;#
	my $plugindataobj = MT::PluginData->load ({
			plugin => $MYNAME,
			key => 'author_id::'. $author_id });
	unless ($plugindataobj) {
		$plugindataobj = MT::PluginData->new
			or return $cb->error ($MYNAME. ': failed to initialize MT::PluginData');
		$plugindataobj->plugin ($MYNAME);
    	$plugindataobj->key ('author_id::'. $author_id);
	}
	my $plugindata = {};
	$plugindata->{mixi_user_id} = $q->param ('mixi_user_id') || 0;
	$plugindata->{mixi_premium} = $q->param ('mixi_premium') || 0;
    $plugindataobj->data ($plugindata);
    $plugindataobj->save
    	or return $cb->error ($plugindataobj->errstr);
}

1;