---
title:  "PyTouch 설치 과정에서 확인한 잡다한 이슈들"

categories:
  - Python
tags:
  - [Python, PyTouch]

img_path: /images/
toc: false
toc_sticky: false

date: 2026-09-24
---

`PyTouch`설치 과정에서 버전 문제 등 잡다한 문제점/의문점들이 여럿 발생했다.<br>
워낙 빠르게 변하는 분야라 구버전에 대한 정보는 대부분 있는데, 최신 버전에서 변경된 부분에 대한 정보가 부족하다는 느낌이었다.

그닥 중요하다거나 큰 문제는 아니지만 현재(2026년 9월 기준) 기준으로 가능한 한 최신화된 정보들을 정리해 보았다.

<h4>PyTouch를 설치할 때 CUDA를 먼저 설치해야 하는가?</h4>

결론만 말하자면 '아니오'다.<br>
2026년 현재 최신 버전의 파이토치는 설치시 CUDA등 필요한 라이브러리가 패키지로 같이 깔리므로 CUDA 툴킷을 따로 설치할 필요가 없다.

>[Is it required to set-up CUDA on PC before installing CUDA enabled pytorch?](https://discuss.pytorch.org/t/is-it-required-to-set-up-cuda-on-pc-before-installing-cuda-enabled-pytorch/60181/22?page=2)

`PyTouch 설치 방법`을 검색하면 많은 포스트나 게시물이 CUDA를 먼저 설치하라고 적혀 있는데, 이것들은 오래된 자료라고 보면 된다.

확인을 위해 기존에 PC에 설치되어 있던 `CUDA`를 제거하고 `PyTouch 2.14.0`를 설치해본 결과, 정상적으로 동작하고 설치 과정에서 지정한 버전의 cuda가 인식되는 것을 확인했다.

![version](20261003.jpg)

마찬가지로 [WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui)도 내부적으로 `venv`를 사용해 파이토치/cuda를 통째로 포함시킨 것으로 보인다.

`LM Studio`는 자체적으로 `llama + cuda`가 내장되어 있어, 따로 설치한 `cuda`를 사용하지 않는 구조이며, 내장 cuda는 스튜디오 버전에 따르는 듯.

> [LM Studio 0.3.15](https://lmstudio.ai/blog/lmstudio-v0.3.15)

> [How can I use CUDA 13 with LM Studio?](https://www.reddit.com/r/LocalLLM/comments/1rgaohj/how_can_i_use_cuda_13_with_lm_studio/)

<h4>const install을 이용한 PyTouch 설치</h4>

파이토치는 현재 conda 인스톨을 권장하지 않으며, 설치 패키지 제작비용 대 효율 문제로 관련 지원을 중단했다.<br>
최신버전은 pip 인스톨을 권장하고, conda로 인스톨할 수 있는 버전은 (CUDA 13버전을 지원하지 않는) Pytouch 2.5/2.7에서 멈춘 상태다.<br>
참고로 2026년 9월 현재 기준 PyTouch의 최신 버전은 2.14이며 CUDA 13.1을 지원한다. 현재 CUDA의 최신버전은 13.2므로 CUDA과 PyTouch를 따로 설치하려 한다면 주의해야 한다.

> [pytorch 설치시 anaconda를 더이상 지원하지 않는다고 합니다.](https://www.inflearn.com/community/questions/1523008/pytorch-%EC%84%A4%EC%B9%98%EC%8B%9C-anaconda%EB%A5%BC-%EB%8D%94%EC%9D%B4%EC%83%81-%EC%A7%80%EC%9B%90%ED%95%98%EC%A7%80-%EC%95%8A%EB%8A%94%EB%8B%A4%EA%B3%A0-%ED%95%A9%EB%8B%88%EB%8B%A4)

> [Pytorch installation for conda](https://forum.anaconda.com/t/pytorch-installation-for-conda/108336/3)

> [[Announcement] Deprecating PyTorch’s official Anaconda](https://github.com/pytorch/pytorch/issues/138506)

<br>

<h4>ipykernel이란?</h4>

파이토치 설치 강좌 중에 ipykernel라는 것을 설치하는 포스팅이 있어서 뭔지 확인해봤다.

[Windows + Miniconda + VS Code + Jupyter + PyTorch(컴퓨터 비전) 환경 구축 가이드](https://markbyun.tistory.com/entry/Windows%EC%97%90-python-%EA%B0%9C%EB%B0%9C%ED%99%98%EA%B2%BD-%EC%84%A4%EC%A0%95)

`Jupyter Notebook`이나 `VS Code`에서 파이썬 코드를 실행할 수 있게 연결해주는 커널 패키지라고 하는데, `anaconda`로 가상화된 실행 환경을 연결하는 것으로도 동작하기 때문에 아나콘다를 쓸 거면 따로 설치하지 않아도 되는 것 같다.