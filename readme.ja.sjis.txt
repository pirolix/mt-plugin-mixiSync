mixiSync 1.41
========================================================================
	mixiSync plugin for MovableType w/ BigPAPI
			Original Copyright (c) 2006 Piroli YUKARINOMIYA
			Open MagicVox.net - http://www.magicvox.net/
			@see http://www.magicvox.net/archive/2006/02041724.php
========================================================================

�� �����
	MovableType 3.2ja2 �ȏ�A���邢�� MovableType 3.16 �ȏ�
	���ʓr�ABigPAPI 1.04 �ȏオ��������������Ă��邱��
	�܂��� MovableType 3.3 �ȏ�
	perl 5.0x �ȏ�

	note: BigPAPI - http://www.staggernation.com/mtplugins/BigPAPI/

	����ɂ� MovableType3.2ja2 + Windows 2000 + Firefox 1.5 or IE 6.0 ���g�p
	MovableType3.31�ł�����m�F 


�� �������@

1.�p�b�P�[�W�Ɋ܂܂��t�@�C���� MovableType �� plugins �ɃR�s�[���܂�

2.�v���O�C���ꗗ�� mixiSync �v���O�C�����ǉ�����Ă��邱�Ƃ��m�F���܂�

3."���e��"�����N���J���A���[�U���Ƀv���O�C���̏����ݒ���s���܂�

	���[�U�̃v���t�B�[����ʂɐV���� mixi �̐ݒ荀�ڂ��ǉ�����Ă��܂�

	a. mixi ���[�U ID �ԍ������Ȃ��̃��[�U ID �ɏ��������܂�

	note:	���[�U ID �ԍ� �� mixi ��"�v���t�B�[��"�y�[�W�ɏ����Ă���܂�
	note:	http://mixi.jp/show_friend.pl?id=XXXXXX �̐��������ł�

	b. mixi �v���~�A�����[�U�o�^������Ă�����́A�`�F�b�N�{�b�N�X���`�F�b�N���܂�

5.�G���g���̕ҏW��ʂ� "�ۑ�" �{�^���ׂ̗� "mixi �V�K���e" �{�^�����ǉ�����Ă��܂�

	note:	Step.3 �̏����ݒ���s��Ȃ��ƃ{�^�����\������܂���


�� �g����

1.MovableType �̕ҏW��ʂŋL���̕ҏW��Ƃ��s���܂�

2.�ҏW���I�������"mixi �V�K���e"�{�^���������܂�

3.mixi ���L�̕ҏW�y�[�W(���L������)���V�����E�B���h�D�ŊJ���܂�

	note:	mixi �ɂ͎��O�Ƀ��O�C�����Ă����Ă�������
	note:	���O�C�����Ă��Ȃ��ꍇ�̓��O�C����ʂ��\������܂�

4.�C������������A�ʐ^��ǉ��ŃA�b�v���[�h������A"�m�F���"�{�^���������܂�

5.���e���m�F����"�쐬"�{�^���������܂�

	note:	���̂�����͑S�� mixi ���L�̎g�����̒ʂ�ł�


�� ���e�t�H�[�}�b�g�̃J�X�^�}�C�Y�ɂ���
	mixiSync �͕W���ŁAMovableType �̊e�G���A�� mixi ���L�̊e�t�H�[���Ɋ��蓖�Ă܂��B
	
		MovableType�F�^�C�g�� �� mixi ���L�F�^�C�g��
		MovableType�F�G���g���[�̓��e (body) �� mixi ���L�F�{��

	�l�ɂ���Ă̓^�C�g���ɏ��蕶������ꂽ��A���L�{���ɒǋL (more)�̓��e���܂߂�ȂǁA
	mixi ���L�̕ҏW��ʂɗ������܂��t�H�[�}�b�g���J�X�^�}�C�Y���邱�Ƃ��ł��܂��B

1.MovableType �̊Ǘ���ʂ���[�e���v���[�g]-[���W���[��]�ƒH��A
�@"mixiSync Entry Template" �Ƃ������O�Ń��W���[���e���v���[�g��V�K�쐬���܂�

2.�쐬�������W���[���e���v���[�g�ɕҏW��ʂ̃t�H�[�}�b�g���ȉ��̗l���ŏ������݂܂�

	diary_title : "<MTEntryTitle> �y�{�ƃu���O���z",
	diary_body : "<MTEntryBody>\n--------\n������<MTBlogName>�ŁI\n<MTEntryPermalink>",

	���W���[���e���v���[�g�Ŏg�p�ł���^�O�͈ȉ��̒ʂ�ł��B

	<MTEntryTitle>
			MovableType �ҏW��ʂ�"�^�C�g��"�ł��B

	<MTEntryBody>
			MovableType �ҏW��ʂ�"�{��(body)"�ł��B

	<MTEntryMore>
			MovableType �ҏW��ʂ�"�ǋL(more)"�ł��B

	<MTEntryExcerpt>
			MovableType �ҏW��ʂ�"�T�v(excerpt)"�ł��B

	<MTEntryKeywords>
			MovableType �ҏW��ʂ�"�L�[���[�h"�ł��B

	<MTBlogName>
			MovableType �u���O�̖��O�ɂȂ�܂��B

	<MTBlogURL>
			MovableType �u���O�̃g�b�v�y�[�W URL �ɂȂ�܂��B

	<MTEntryPermalink>
		�L�����p�[�}�����N�����ꍇ�A�L���ւ̃p�[�}�����N�ɂȂ�܂��B
		�L�������J����Ă��Ȃ��Ȃǂ̗��R�Ńp�[�}�����N�������Ȃ��ꍇ�A�u���OURL�Ɠ����ł��B

	\n �܂��� <br>
			���s�����ɕϊ�����܂��B

	note:	MovableType �̃e���v���[�g�^�O�Ɏ����Ă��܂����A�S���̕ʕ��ł��B
			���̂��� MovableType �̃t�B���^��I�v�V�����w��͂ł��܂���B

	note:	���W���[���e���v���[�g�̓��e�� JavaScript �R�[�h�̈ꕔ�Ƃ��ĉ��߂���܂��B
			���p�����ɒ��ӂ��A���ꕶ���Ȃǂ̓G�X�P�[�v����K�v������܂��B
			�ڍׂȐ����͓K���� JavaScript �̉���y�[�W���Q�Ƃ��Ă��������B


�� MovableType �L������ HTML �^�O�̈����@(New! v1.10-)
	mixiSync �� mixi ���L�ɋL�����e���R�s�[���鎞�ɁA�L������ HTML �^�O���C�����܂��B

	�v���~�A������̏ꍇ
		<br>, <p> �͉��s�����ɒu���������܂�
		<hr> �� ---------------------------------------- �ɒu���������܂�
		�g�p�ł��� HTML �^�O�͈ȉ��̒ʂ�ł��B�����ȊO�� HTML �^�O�͍폜����܂�
			a,strong,em,u,blockquote,del

	��v���~�A������̏ꍇ
		<br>, <p> �͉��s�����ɒu���������܂�
		<hr> �� ---------------------------------------- �ɒu���������܂�
		<a href="http://www.yahoo.co.jp/">Yahoo!</a> �� Yahoo!(http://www.yahoo.co.jp/) �ɒu���������܂�
		���� HTML �^�O�͑S�č폜����܂�


�� �g�p��������
	���̃\�t�g�E�F�A�p�b�P�[�W�̓��e�ɂ��Ă͊��S�ɖ��ۏ؂ł��B
	���̃\�t�g�E�F�A�p�b�P�[�W�̔z�z����ςɊւ��������
	The Artistic License (http://www.opensource.jp/artistic/ja/Artistic-ja.html)
	�ɏ�������̂Ƃ��A����ɏ]�����莩�R�ɂ��邱�Ƃ��ł��܂��B

	This code is released under the Artistic License.
	The terms of the Artistic License are described at
	http://www.perl.com/language/misc/Artistic.html


�� �ӎ�
	Realtime Preview �v���O�C���̍쐬�ɂ������Ă͎��̃y�[�W���Q�l�ɂ����Ē����܂����B
		BigPAPI (c)Kevin Shay
			http://www.staggernation.com/mtplugins/BigPAPI/

	���̃v���O�C���쐬�̂����������������� Dakiny ����̈ꌾ�Ɋ��ӂ��܂�(��

	�o�O�񍐂�v�]�𒸂������[�U�̊F�l�A�����ċM���B


�� ���䗠�Șb

0.XSS�ɂ����
	�J�����̃o�[�W�����͂�����JavaScript�̔䗦������������ł����A
	��̂ł����Ƃ����CrossSiteScripting��㩂Ɉ����������č�蒼���H�ڂɁI

1.mixi ����̎h�q!?�@<input name="submit" value="main">
	�����̗\��ł�"mixi�V�K���e"�{�^�����������i�K�ŁA���e�m�F��ʂɔ�΂����������Ƃ���A
	document.form_name.submit (); ���ǂ����Ă��G���[�ɂȂ� orz
	�����������ǂ��킩�炸��������Ă����Ƃ���A�����͓��̓t�H�[���̈��
		<input name="submit" value="main">
	�������Bfunction submit �� submit �Ƃ������O�� HTMLInputElement �ŏ㏑������Ă����̂ł����c
	�F�X�����Ă݂��񂾂��ǒf�O�B���ʁA���L�̕ҏW�y�[�W�ɔ�΂���Ă��܂����ƂɁB
	// �ł����̂܂܂̂��֗����ȁH

2.�����R�[�h����
	mixi �� EUC-JP �ɑ΂��AMovableType ���̂���͐l���ꂼ��Bform �� accept-charset �����ŉ����I
	�c�̃n�Y�������񂾂��� IE ��p�ɕʏ������K�v�ł����B����ɂ��B

3.��҂��r�b�N��
	mixi���L�ɂ�<MTEntryBody>�����f�ڂ��ċL���̊T�v�������A
	�L���{�̂�<MTEntryPermalink>�Ń����N�\���Ă������
	�O���u���O�]�X�̃����N�b�V������u�����ɔ�ׂăn�b�s�[�Ȋ����B
	�ĊO�C�C����(��ͥ)b


�� �X�V����
'06/12/05	1.41	MT3.3 �� Transformer �ɑΉ��B3.3 �ł� BigPAPI �������Ă����삵�܂��B
'06/08/29	1.40	MT3.3 �œ��삵�Ȃ������s��C��
			�����̓��e�҂����݂���ꍇ�A���e�Җ��Ƀ��[�UID��ݒ�ł���悤�ɂ���
'06/04/12	1.31	�ꕔ���œ��삵�Ȃ��s��C��
					tenu ����(http://tenu.vis.ne.jp/)�A���肪�Ƃ��������܂����I
'06/04/10	1.30	�t�@�C������{��
					MT �̐ݒ�X�^�u���g�p���Đݒ���s����悤�ɂ���
'06/02/27	1.21	���`���ꂽ�����N�ɃS�~���t���s��C���@'$2($1)' �� '$2( $1 )'
'06/02/09	1.20	mixi �d�l�ύX�ɂ������S�b�R�����ڂɑΉ�
'06/02/07	1.11	�v���~�A������Ŏg�p�ł���HTML�^�O�ɂ͐G��Ȃ��悤��
'06/02/05	1.10	HTML�^�O�̃T�j�^�C�Y
					�v���~�A�����/�����ŏ������e���`���b�g�Ⴄ(^^)
'06/02/04	1.00	���Ō��J
