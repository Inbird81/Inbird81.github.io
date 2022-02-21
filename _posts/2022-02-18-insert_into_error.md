---
title:  "[C++/C#] INSERT INTO 문의 구문 오류입니다
"

categories:
  - C++
tags:
  - [ADO.NET]

img_path: /images/
toc: false
toc_sticky: false
 
date: 2008-12-24
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2010년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

mdb를 ADO.NET로 사용할 때 이 오류 때문에 한시간 반 가까이를 헤맸다.

당연히 insert 쿼리문 자체에는 아무 문제도 없고, 문제가 된 쿼리문을 복사해서 Access에서 직접 실행해봐도 정상적으로 작동한다.

문제가 된 쿼리문(정확히는 문제가 뭔지 테스트하기 위해 만든 쿼리)는 이렇다.

```sql
insert into TB_MEMOTEST (MEMO) values ("테스트")
```

에러의 원인은 구문 자체가 아니라, MEMO가 mdb의 예약어이기 때문이다.

그런데 어째서인지 테이블을 설계할 때는 아무 말도 없다. 액세스 내에서 쿼리를 실행할 때도 전혀 에러가 안 난다. ado로, 그것도 select의 경우는 문제 없고 update나 insert를 실행할 때만 '구문 오류입니다'라는 에러를 내놓을 뿐이다.

내가 mdb를 처음 써본 탓도 있지만, 에러 메세지 좀 제대로 내주면 어디 덧나나? 크리스마스 이브에 야근하는 것도 열받는데...-_-+
