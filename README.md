SaveWithBackup for Coda
========================

이건 [Coda](http://www.panic.com/coda)를 위한 플러그인입니다.<br />
Coda의 백업 없는 원격 경로 저장은 종종 소스의 유실을 초래하곤 하는데, 이를 위해 저장할 때 함께 백업하게 해줍니다.<br />


Installation
------------

[다음 페이지](http://devbug.me/647)를 방문하여 첨부된 SaveWithBackup.codaplugin_1.0.zip 파일을 받습니다.<br />
압축을 해제한 후 나온 파일을 실행합니다.<br />


Usage
------

Command+S 대신에 Ctrl+Shift+S 로 저장을 하세요!<br />
그러면 알아서 백업하며 저장을 해줍니다.<br />
백업 파일은 `~/SaveWithBackup/` 아래에 remote 경로 그대로 백업되니까 쉽게 찾을 수 있습니다!<br />


License
-------

Source code는 GPL을 따릅니다.<br />
Executable binary는 [BPL](http://devel.oops.org/document/bpl)을 따릅니다.<br />
각각 라이센스가 다르므로 유의해주시기 바랍니다.<br />


Compile
-------

컴파일을 위해선 다음 헤더파일이 추가적으로 필요합니다.<br />
TSDocument.h<br />
TSNodeWrapper.h<br />
TSTabController.h<br />
TSWrapperViewController.h<br />
PCNode.h<br />
본 파일들은 제게 배포권이 없으므로 배포하지 않습니다.<br />

CodaPlugInsController.h 파일은, 실수로 빼먹었습니다. 데헷~☆<br />
[다음 링크](http://www.panic.com/coda/d/Coda%20Sample%20Plug-ins.zip)를 통해서 다운받을 수 있습니다.<br />

