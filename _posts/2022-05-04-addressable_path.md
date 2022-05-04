---
title:  "[Unity] Addressable에서 Build/Load Path 설정"

categories:
  - Unity
tags:
  - [Unity]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-05-04
---

어드레시블을 써본 감상은 이건 '원격 저장소에서', '비동기로' 읽어오는 것에 초점을 맞춰 만들어진 툴이구나, 하는 것이었다.

'비동기' 쪽의 문제는 [이전 게시물](/posts/addressable/)에서 이야기했는데, 개인적으로 더 고생한 문제는 저 '원격 저장소' 쪽이었다.

물론 어드레시블은 에셋을 로컬에 두고 쓰도록 설정할 수 있는데, 문제는 이 부분의 문서나 관련글을 찾기가 의외로 어려웠다는 점이다.

어드레시블의 사용법 자체는 여기저기 설명된 게 많으며, 내가 참고한 게시물들은 다음과 같다.

> [어드레서블 에셋 시스템 - 개념: 어드레서블 윈도우, 시스템 동작 플로우](https://planek.tistory.com/23)

> [Unity - 어드레서블(Addressable)](https://velog.io/@kimwonseop/Addressable)

> [어드레시블 강좌글 목록](https://m.blog.naver.com/PostSearchList.naver?blogId=cdw0424&orderType=sim&searchText=%EC%96%B4%EB%93%9C%EB%A0%88%EC%84%9C%EB%B8%94)

> [어드레서블 에셋 시스템으로 메모리 최적화하기](https://m.blog.naver.com/unity_kr/222447080302)
이쪽은 유니티 공식 블로그

내가 고생했던 부분은 어드레시블의 설정 중, Build / Load Path에 관한 것이었다.

어드레시블은 각 에셋 그룹의 설정에서 에셋이 빌드 후 저장되는 경로와 실제 플레이 시 에셋을 로드할 경로를 설정한다.

![Group setting](2022-05-04-1.PNG)

여기서 로컬 에셋의 경우 LocalBuildPath / LocalLoadPath를 기본값으로 사용한다.

이 기본 경로도 바꿀 수 있고, 혹은 Custom을 선택해 수동으로 경로를 입력할 수도 있다. LocalBuildPath/LocalLoadPath의 값 자체는 Manage Profile 메뉴에서 설정 가능하다.

![Profile setting](HostingServicesProfiles_1.png)

문제는 이 경로가 정확히 어디인지에 대한 설명이 없다는 것이다.

[UnityEngine.AddressableAssets.Addressables.BuildPath]는 다행스럽게도 에디터에서 바로 확인할 수 있다.

![BuildPath](2022-05-04-2.png)

그런데 Load Path인 {UnityEngine.AddressableAssets.Addressables.RuntimePath}는 바이너리 실행 경로의 상대위치라서인지 정확한 위치를 알려주질 않는다.

아니, 저기가 Load Path면 배포할 때 저 경로에 에셋들을 복사해서 같이 배포해야 하는데, 경로가 어딘지 모르면 어쩌라고?

황당해서 한참을 뒤져봤지만, 아무리 뒤져도 저 RuntimePath가 정확히 어디인지를 알려주는 곳은 없었다.

윈도우 버전에서는 이게 별 문제가 되지 않는다. LocalLoadPath를 무시하고 경로를 수동으로 입력할 경우, 바이너리 파일(.exe)의 경로로부터의 상대 경로로 지정되기 때문이다.

그러니까 이렇게 설정하는 게 LocalBuildPath/LocalLoadPath보다 낫다.

![Path](2022-05-04-3.png)

이렇게 하면 에셋이 바이너리가 빌드되는 경로 아래에 저장되므로 별도로 옮기고 할 거 없이 그대로 배포하면 된다.

이게 정석적인 방법인지 편법인지는 모르겠지만 나는 이렇게 해서 지금까지 문제가 된 적은 없었다.

그런데, 최근에 이렇게 개발된 게임을 모바일 버전으로 빌드해서 보고 싶다는 클라이언트의 요청이 있었다. 

그냥 모바일 화면에서 어떻게 보이는지 테스트하고 싶다는 거라(적어도 일단은) 별 문제 없겠거니 했는데...

{UnityEngine.AddressableAssets.Addressables.RuntimePath}가 안드로이드에서는 정확히 어디인지를 알 수가 없었다.

안드로이드에서는 경로를 수동으로 지정했을 때의 기준점, 그러니까 '/'가 어디인지를 알 수가 없기 때문에 LocalBuildPath를 써야 하는데, 이게 어딘지에 대한 이야기가 없다.

이거 때문에 이틀 가까이를 개고생하다가, 간신히 단서를 찾을 수 있었다.

> Those files are generated when you build Addressables data, and wind up in the StreamingAssets folder.<br>
-[Local Data in StreamingAssets](https://docs.unity3d.com/Packages/com.unity.addressables@0.7/manual/AddressableAssetsGettingStarted.html#local-data-in-streamingassets)

> The Addressables system only copies data from Addressables.BuildPath to the StreamingAssets folder during a Player build -- it does not handle arbitrary paths specified through the LocalBuildPath or LocalLoadPath variables. If you build data to a different location or load data from a different location than the default, you must copy the data manually.<br>
-[Addressable Assets Profiles](https://docs.unity.cn/Packages/com.unity.addressables@1.18/manual/AddressableAssetsProfiles.html)

빌드 단계에서 Addressables.BuildPath에 있는 파일들이  StreamingAssets으로 복사된다고?

지푸라기라도 잡는 심정으로 직접 로그를 찍어서 확인해보기로 했다.

안드로이드 APK에서 StreamingAssets의 경로는 `"jar:file://" + Application.dataPath + "!/assets`다.

확인을 위해 LocalBuildPath/LocalLoadPath의 값을 디폴트로 두고 빌드해본 후 apk 파일을 열어보니, 정말로 에셋이 apk 안에 들어 있었다.

![BuildPath](apk.png)

정확히는 `assets/aa` 폴더 아래고, profile 설정을 아예 건드리지 않았다면 `assets/aa/android` 일 수도 있다.

이걸 제대로 읽어오는지 확인을 위해 로그를 박고 Logcat에서 확인해보았다.

![Log](logcode.PNG)

그리고 실행해 본 결과, 정상적으로 apk 내의 경로에서 에셋을 읽어오는 것을 확인할 수 있었다.

![Log](runtimepath.PNG)

왜 이걸 알아내는 게 이렇게 어려웠는지는 모르겠다.<br>
별로 고민할 필요가 없는 문제라서 그럴 수도 있다. 모바일의 경우 그냥 기본 설정을 쓰면 알아서 apk 내에 에셋이 저장되니까.<br>
아니면 assetbundle이나 streamingasset에 대한 지식이 있으면 너무 상식적인 거라 별도의 글로 정리할 필요가 없어서일 수도 있고, 단순히 내 검색능력이 형편없었던 걸 수도 있다.<br>
하지만 어쨌든 나는 이걸 알아내기 위해 며칠동안 삽질을 해야 했고, 나같은 사람이 더 있을지도 모르기 때문에 정리를 해 둔다.

3줄 요약:
- addressable에서 LocalBuildPath는 어디인지 알기 쉽지만, PC 빌드의 경우 귀찮은 곳에 짱박히므로 수동설정해두면 편하다.
- PC판의 경우 LocalLoadPath는 어딘지 모르겠는데, 이것도 그냥 수동 설정해버리면 편하다.
- 안드로이드에서 LocalBuildPath/LocalLoadPath를 디폴트 값으로 놔두면 알아서 apk 내에 에셋이 포함된다.
