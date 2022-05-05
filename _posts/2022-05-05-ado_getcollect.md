---
title:  "C++ ADO에서 GetCollect()의 인수로 칼럼 번호를 넣을 때 유의사항"

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

C++ ADO 라이브러리 사용시, 다음과 같은 코드는 에러를 낸다.

```c++
_RecordsetPtr rs;
.
.
rs->GetCollect(0);
.
.
```

결과 레코드셋에 값이 있어도 에러가 나는데, 이를 해결하는 방법은 다음과 같다.

```c++
rs->GetCollect((short)0);
```

아무래도 GetCollect()의 인수로 칼럼 번호를 넣을 때는 short형이 아니면 안 되는 듯.
