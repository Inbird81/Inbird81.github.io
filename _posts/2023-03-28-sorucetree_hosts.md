---
title:  "SourceTree에서 로그인 관련 문제 발생시 대처법"

categories: [etc]
tags:
  - [etc]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-03-28
---
SourceTree 사용중에 원격 리포지터리를 clone하려고 했더니 로그인 ID/패스워드를 입력하는 창에 잘못된 ID가 고정되어 있고 입력창에서 바꿀 수 없는 문제가 있었다. 뻔하게 틀린 ID인데 이걸 바꿀 수가 없으니 황당했는데, 대체 뭐가 문제인지 찾아본 결과 SourceTree는 로그인 계정을 하나만 취급한다는 글을 발견했다.

> [SOURCETREE 오류 - 원격저장소 로그인 정보 삭제 하기](https://programmingjournal0813.tistory.com/8)

> [Sourcetree change password of existing account](https://stackoverflow.com/questions/43391223/sourcetree-change-password-of-existing-account)

SourceTree에서 계정정보를 바꾸는 방법은 옵션의 설정 등 여러 가지가 있지만 제대로 동작하는지 확실하지 않고, 대부분 가장 확실한 방법으로 password/userhosts 파일을 삭제하라고 하고 있다.

이 파일들이 있는 위치는 `C:\Users\<username>\AppData\Local\Atlassian\SourceTree`이고, 사무실 PC에서 발생했던 문제는 이 방법으로 해결했다.

문제는 집의 PC에는 해당 위치에 password/userhosts 파일이 없다는 것이다.
windows 11이 문제인가 싶어서 검색해봤지만 찾아봐도 딱히 나오는 것은 없었다.
소스트리의 최신버전이 계정 저장방식을 바꾼 것인지 windows 11의 문제인지, 단순히 내가 뭔자의 이유로 파일을 못 발견한 건지 모르겠다.

일단 `C:\Users\<username>\AppData\Local\Atlassian\SourceTree\accounts.json`파일이 계정정보로 추정되는 것을 보관하고 있는 것은 확인했지만, 이게 기존의 password/userhosts 파일을 대체하는지는 알 수 없었다.

그 외에 소스트리 내에서 계정을 관리하는 곳은 다음과 같다.

- 도구->옵션->일반->전역 사용자 설정
- 저장소별 설정->고급->사용자 정보->전역 사용자 설정 사용 체크

이 계정문제는 늘 잊을만하면 한번씩 터지고, password/userhosts 파일이 없는 문제는 아직도 원인을 찾지 못해서 일단 확인된 것들만 정리해둔다.