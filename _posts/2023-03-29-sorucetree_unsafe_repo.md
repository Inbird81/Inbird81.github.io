---
title:  "SourceTree에서 failed code 128: fatal unsafe repository 에러 해결법"

categories: [etc]
tags:
  - [etc]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-03-29
---
이번에 PC를 교체하고 SourceTree를 새로 깔았는데 이 블로그가 저장된 리포지터리를 등록하려고 하니 에러가 발생했다.

![unsafe repository](2023-03-29-1.png)

나는 github 블로그를 [시놀로지 NAS에서 돌리기](https://inbird81.github.io/posts/install-jelyll-Synology-nas/) 때문에 이 블로그의 소스가 있는 리포지터리는 네트워크 드라이브(Z:)에 있었는데, 이게 뭔가 보안 문제를 일으키는 거라는 추측은 쉽게 할 수 있었다.

하지만 전에는 멀쩡하게 되던 게 소스트리 새로 설치하니까 안 되는건 뭐란 말인가?

대체 뭔 문제인가 하고 찾아보니 Git이 업데이트되면서 보안 관련으로 뭔가 추가되어서인 것 같다. 상당히 많이 발생한 문제여서인지 열받은 사람들도 많았던 모양.

> [Fix that damn Git Unsafe Repository](https://weblog.west-wind.com/posts/2023/Jan/05/Fix-that-damn-Git-Unsafe-Repository)

가장 많이 나오는 답변은 Git Config를 설정하는 것이었다. 방법은 다음과 같다.

```powershell
git config --global --add safe.directory <Git folder>
```

하지만 이대로 해봐도 전혀 해결이 되지 않았다.
뭐가 문제인지 찾던 도중 나와 같은 문제를 겪는 사람을 찾아냈다.

> [소스트리 unsafe .. owned by soneone else 에러](https://manggong.org/153)

요약하자면, git config로 safe 경로를 등록할 때 디렉토리를 리눅스 스타일로 `/`로 구분해야 한다는 것이다. `\`나 `\\`로 되어 있으면 안 먹힌다.

경로를 윈도우 탐색기에서 붙여넣으면 저 부분에서 문제가 생긴다. 이것도 위에 링크한 포스트 작성자가 나와 동일하게 겪은 문제다.

git의 설정은 C:\Users\<username>\.gitconfig 파일에 저장되는데, 여기에 `[safe]`라는 항목에 관련 설정이 저장된다. 위의 커맨드를 입력하고 파일을 열어보면 등록한 폴더 경로를 확인할 수 있는데, 이 파일을 수정하고 SourceTree를 재시작하면 바뀐 설정이 적용된다.

하지만 내 경우, 여기까지 해도 문제가 해결되지 않았다.
네트워크 드라이브 경로는 safe.directory로 지정해도 안되는건가? 하지만 NAS에서 블로그를 돌리려면 다른 곳으로 옮길 수가 없는데...
그런 생각을 하면서 에러메세지를 다시 보니 눈에 띄는 부분이 있었다.

![unsafe repository](2023-03-29-1.png)

메세지에는 네트워크 드라이브 경로에 대해 `%(prefix)///SynologyNAS720/Data/Inbird81.github.io`를 넣으라고 되어 있다. 
나는 당연히 앞의 `%(prefix)`는 뭔가의 오류로 출력된 것이고 `//`부터가 정상적인 경로일 거라고 생각했는데, 혹시나 싶어 앞의 `%(prefix)`까지 그대로 넣어보니 정상적으로 동작했다.

확실히는 모르겠지만 저거 자체가 `\\`를 표기하기 위한 코드로 같이 들어가야 하는 것 같다.

그리고 에러 메세지 자체에 경로가 `/`로 표시되어 있다. 이 메세지를 복붙할 수 있었으면 오히려 금방 해결됐을지도 모르는데, 왜 메세지창 텍스트는 copy & paste가 안 되는 걸까...

추가로, safe.directory에 네트워크 드라이브의 드라이브 경로(`z:/xxxx`)를 넣어도 동작하지 않는다. `//`로 시작하는 네트워크 경로만 인식하는 것 같다.