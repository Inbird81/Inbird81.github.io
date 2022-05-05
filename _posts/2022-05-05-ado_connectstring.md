---
title:  "C++ ADO에서 Connection string 주의점."

categories:
  - C++
tags:
  - [C++]

img_path: /images/
toc: false
toc_sticky: false

date: 2010-4-15
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

ADO.NET에서 MSSQL에 접속시 Connection String은 다음과 같다.

>Data Source=[address];Initial Catalog=[DB name];User ID=[ID];Password=[PASSWD]

C++에서 쓰는 ADO에서는 약간 다르다.

>provider=SQLOLEDB.1;Data Source=[address];Initial Catalog=[DB name];User ID=[ID];Password=[PASSWD]

C++에서는 앞에 `provider=SQLOLEDB.1;` 가 포함되어야 한다.

이걸 몰라서(정확히는 까먹어서) 세 시간정도 삽질했음 ㅁㄴㄹㅇ...

참고로 빼먹었을 때 나타나는 메세지는 다음과 같다.

>Error Code: 80004005
Description: [Microsoft][ODBC 드라이버 관리자] 데이터 원본 이름이 없고 기본 드라이버를 지정하지 않았습니다.