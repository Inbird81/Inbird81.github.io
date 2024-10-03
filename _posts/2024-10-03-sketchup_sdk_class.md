---
title:  "Sketchup SDK Interface class들의 사용"

categories:
  - Sketchup SDK
tags:
  - [Sketchup SDK]

img_path: /images/
toc: false
toc_sticky: false

date: 2008-11-5
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2024년 현재의 환경과는 맞지 않을 수 있습니다._

Managed C++은 거의 다뤄 본 적도 없고, Turbo C 2.0 시절에 C를 배웠다가 회사에 와서는 5개월간 자바만 두드린 탓에 C++ 코드 분석하기가 상당히 골때였는데..

특히 이놈의 QueryInferface()는 뭐하는 물건인지 몰라서 한참 헤맸다.

> [http://blog.naver.com/ratmsma?Redirect=Log&logNo=40025129098](http://blog.naver.com/ratmsma?Redirect=Log&logNo=40025129098)

대강 서로 다른 버전의 COM 인터페이스들을 연동하는 역할이라고 하는데, COM을 공부한 적이 있어야지.. -_-; 
대충 뒤져보니 사용법은 이런 식이다.

```c++
00005     ISkpApplicationBridge* pAppProvider = NULL;
00006
00007     hr = pApp->QueryInterface(IID_ISkpApplicationBridge, (void**)&pAppProvider);
00008
00009     if(FAILED(hr)) return hr;
00010
00011     hr = pAppProvider->GetSkpApplication(ppSkpApp);
```

스케치업 SDK의 인터페이스들은 서로 같은 클래스를 상속받는 것들이 있다.

예를 들면,<br>
![class](20081105_2.jpg)<br>
위의 인터페이스 4개는 모두 SkpFace 클래스를 상속받으므로 각 인터페이스들간에 QueryInterface()함수로 전환이 가능한 것.

하지만, 직접 해보니 같은 버전 내에서는 굳이 저런 함수를 쓸 필요도 없이, 바로 대입이 가능했음.

예를 들어<br>
```c++
  ISkpFacePtr pFace = ...;
  iSkpEntityPtr pEnt = pFace;  
```
이런 식으로 직접 대입이 가능.

참고로 ...Ptr 시리즈는 API 도큐먼트에는 없고, 내가 사용중인 dll에만 스마트포인터로 typedef되어 있다.

일단 돌아가긴 돌아가지만, 이쪽 지식은 거의 깡통이라 제대로 이해하고 있는 건지... ㅁㄴㅇㄹ