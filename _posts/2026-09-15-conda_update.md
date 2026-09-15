---
title:  "conda update시 NoBaseEnvironmentError가 발생하는 원인"

categories:
  - Python
tags:
  - [Python, Anaconda]

img_path: /images/
toc: false
toc_sticky: false

date: 2026-09-15
---

[Jupyter](https://jupyter.org/)를 설치하면서 기존에 설치된 Python을 제거하고 [Anaconda](https://www.anaconda.com/)에서 파이썬을 관리하기로 했다.<br>
파이썬의 삭제와 아나콘다의 설치 자체는 문제가 없었지만, 기존에 설치된 파이썬 프로젝트나 연결된 VSCode같은 툴이 여기저기서 문제를 일으켜서 관련 내용들을 정리해두기로 한다.

아나콘다 설치 후 최신 버전으로 업데이트하기 위해 내부에서 `conda update`를 실행했는데, `NoBaseEnvironmentError`가 발생하며 업데이트가 진행되지 않았다.

![NoBaseEnvironmentError](20260915_1.jpg)

이 에러를 구글신께 물어봤더니 아래의 Stack Overflow 게시물 하나만 떴다. 

> [Anaconda won't update: "No default base environment" error](https://stackoverflow.com/questions/62541017/anaconda-wont-update-no-default-base-environment-error)

답변 내용은 `~/anaconda3/conda-meta/`에 `history`라는 이름의 파일이 없어서 발생하는 문제이며, 이 이름의 빈 파일을 생성하면 해결된다는 것이다.

> [NoBaseEnvironmentError](https://github.com/conda/conda/issues/8930#issuecomment-653465668)

출처인 아나콘다 github issue 내용.

적힌 설명대로 `history`파일을 생성했더니 문제가 해결되는 것을 확인했다.

이런 류의 오류에서 구글 검색 결과가 딱 하나밖에 없는 경우는 드문 일이라서 매우 신기했다. 왜 이렇게 되었는지는 모르겠지만 흔하게 일어나는 문제는 아닌 것 같다.