---
title:  "Anaconda 설치 관련 잡다한 이슈들"

categories:
  - Python
tags:
  - [Python, Anaconda]

img_path: /images/
toc: false
toc_sticky: false

date: 2026-09-15
---

Python을 [Anaconda](https://www.anaconda.com/)에서 관리하도록 바꾸는 과정에서 여러 문제가 발생했었다.<br>
이 중 두 개는 별도의 포스팅으로 정리했고, 나머지 자잘한 것들은 그냥 모아서 정리했다.

<h3>Anaconda로 설치한 Jupyter의 시작 위치 변경하기</h3>
Jupyter Notebook를 Anaconda로 설치하면 실행시 시작 폴더가 `\User\[사용자명]`이다. 이 시작 위치를 변경하려면, 아나콘다 설치시 자동으로 시작 메뉴에 생성되는 Jupyter Notebook 바로 가기의 속성을 변경해주면 된다.

1. 시작 메뉴의 Jupyter Notebook항목을 우클릭해서 `파일 위치 열기`를 선택한다.

2. 폴더에서 주피터 노트북 바로가기 파일을 우클릭해서 `속성`을 선택한다.

3. 대상(T)에 있는 실행 경로를 다음과 같이 수정한다.

> ......\Scripts\jupyter-notebook-script.py %USERPROFILE%<br>

=><br>

> ......\Scripts\jupyter-notebook-script.py [시작 폴더 경로]

![noversion](20260915_6.jpg)

이렇게 하고 시작 메뉴를 통해 Jupyter를 실행하면 시작 경로가 바뀐 것을 확인할 수 있다. 

> [[Jupyter Notebook(주피터 노트북)] 시작 폴더 위치 변경](https://takeheed.tistory.com/2)

위 블로그 포스트를 참고했다. 다만 `jupyter_notebook_config.py`를 생성하고 설정을 변경하는 작업은 필요 없고, 그냥 시작 메뉴의 실행경로 수정만으로도 가능하다.

이 블로그 말고도 검색해본 곳에서는 다들 똑같이 `jupyter_notebook_config.py`를 다루고 있어서 어느 쪽이 맞는지는 모르겠는데, 일단 나는 이 과정 없이 시작 폴더가 정상적으로 변경되는 것을 확인했다. 시작 메뉴 외의 다른 경로로 실행하면 당연히 적용이 안 되겠지만...
<br>

<h3>Anaconda로 설치한 Jupyter의 경로</h3>
이건 그냥 궁금해서 찾아본 것인데, 시작 경로가 아닌 Jupyter 자체의 실행 파일이 있는 위치는 `[Anaconda 설치 폴더]\Scripts`로 추정된다.

만약 별도의 실행 환경(Environments)을 만들고 거기 Jupyter를 설치했다면, `[사용자 폴더]\.conda\envs\[환경 폴더명]\Scripts`가 될 것이다.
<br>

<h3>Anaconda가 VS Code를 자동으로 추가하는 문제</h3>
아나콘다를 설치하고 Anaconca Navigator를 실행해 보면 아래 사진과 같이 VS Code가 기본 설치되어 있는 것을 볼 수 있다. 심지어 저건 언인스톨할 수도 없다.

![vs code가 기본으로 들어가 있는 모습](20260915_7.jpg)

 문제는 내 PC 에는 이미 VS Code가 설치되어 있었기 때문에, 이게 기존 설치화 연동된 것인지 별도로 설치한 것인지를 알 수가 없다는 점이었다.

 실행해서 정보를 보면 버전이나 Commit 값 등은 일치하는데 다른 설정으로 실행되는 문제가 있었다. (기존에 설치된 VSCode는 영어 설정인데 아나콘다에서 실행하면 한글 설정으로 뜨는 등)

 확인차 한쪽 버전을 업데이트해본 결과 양쪽 모두 같이 버전이 바뀌는 것을 확인했으며, 아마도 기존 설치를 인식해서 연동된 것이라는 결론을 내렸다. 왜 설정이 다르게 떴는지는 모르겠지만...
<br>

<h3>Anaconda Cloud Notebooks</h3>

![Anaconda Cloud Notebooks](20260915_8.jpg)

아나콘다 네비게이터를 켜보면 이렇게 `Anaconda Cloud Notebooks`라는 게 있는데, 클라우드 호스팅 `Jupyter`라는 설명이 적혀 있다.
삭제할 수도 없고, 이게 아나콘다 설치시 기본으로 같이 깔리는 주피터 노트북인지 의심했었는데, 설치되는 주피터는 로컬이고 이건 그냥 웹 서비스 링크뿐인 것으로 보인다.
<br>
아나콘다 개발사도 돈 벌고 싶은 건 이해하는데, 아나콘다를 자기 PC에 설치한 시점에서 주피터를 클라우드 호스트로 쓸 생각 따위 없다는 의미 아닌가? 사업 아이템으로는 잘못 생각한 것 같기도 하고...

<h3>기존 Python을 쓰는 어플리케이션과의 연동</h3>
이미 Python을 쓰던 상태에서 삭제하고 아나콘다에서 관리하는 걸로 바꿨기 때문에, 기존 파이선의 인스톨 폴더를 참조하는 설정이 남아 있어서 문제가 생기는 경우가 있었다.

내 경우 문제가 생긴 것 중 하나는 [WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui)였는데, 기존 버전에 맞는 파이썬(3.10)을 아나콘다가 관리하는 환경으로 설치하고 `\venv\pyveng.cfg` 파일에 있는 설정에서 기존 경로를 환경이 설치된 경로로 바꾸니 정상 실행되었다.

```console
home = C:\Users\user\.conda\envs\sdwebui
include-system-site-packages = false
version = 3.10.10
```

2026년 현재 `AUTOMATIC1111's WebUI`를 쓰는 사람은 거의 없겠지만 혹시 모르니 기록해둔다.
