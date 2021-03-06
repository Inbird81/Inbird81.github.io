---
title:  "Synology Nas에서 Gitea 사용하기"

categories:
  - etc
tags:
  - [Git, Synology]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-05-01
---
블로그에 글을 올리려고 보니 거의 3달이 지나 있었다.
거의 3달을 게으름으로 날려먹은 셈이니, 자괴감이 이만저만이 아니다.
원래 이 포스팅도 2월달에 NAS 세팅하고 올라갔어야 할 글인데...

원래 NAS를 지른 이유는 개인용 겸 지금 일하는 팀에서 쓸 Git 서버를 구축하기 위해서였다. 팀에서 서버로 쓰던 PC가 맛이 가버려서, 개인서버 구축하는 김에 같이 쓸 계획이었다.

원래는 gitlab을 깔 생각이었지만, 막상 설치하고 확인해보니 이건 개인용으로 돌리기에는 너무 무거운 물건이었다.
일단 메모리를 2gb 넘게 먹는데다, 기능도 상당히 복잡했다. 개인용 서버 구축보다는 github같은 커뮤니티 구축에 더 어울릴 것 같았다.

이 정도로 강력한 기능은 필요하지 않아서, 좀 더 가볍고 쉽게 쓸 수 있는 git 서버를 찾다가 [gitea](https://gitea.io/)를 발견했다.

사용해본 감상은 꽤 만족스러웠다. 가볍고, 있을 건 다 있다.
사실 거의 나 혼자 쓰는 서버고 프로젝트 관리도 프로세스도 없는 거나 마찬가지라 기능은 딱히 쓰는 것도 없고.

설치 작업에 참고한 포스팅과 영상 주소는 다음과 같다.
><https://itslog.tistory.com/entry/Gitea-in-docker>

><https://youtu.be/jTwtna4BuxE>
<iframe width="800" height="400" src="https://www.youtube.com/embed/jTwtna4BuxE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


설치는 Docker에서 gitea를 검색해서 이미지를 다운받은 후 등록하면 된다.

![Docker](2022-05-01-1.PNG)

그 다음 포트를 설정해준다. gitea는 22번(SSH)과 3000번 포트를 사용하며, 보안을 위해 로컬 포트는 적당히 다른 걸로 연결해주는 것이 좋다.

![Port Setting](2022-05-01-2.PNG)

꼭 필요한 작업은 아니지만, 나는 Gitea의 주요 파일들에 직접 접근하기 위해 주요 경로에 마운트를 걸어뒀다.
Gitea의 설정 파일을 건드리거나 로그를 확인하거나 할 때는 도커의 console로 컨테이너에 접근해야 하는데, 이게 상당히 불편하다.
마운트를 걸어두면 그럴 필요 없이 연결된 폴더에서 바로 파일을 수정할 수 있다.
내 경우는 혹시나 싶어서 저장소 폴더에도 마운트를 걸어뒀다.

![Mount](2022-05-01-3.PNG)

참고한 블로그와 영상에서는 시놀로지 역방향(Reverse) 프록시 설정에 대한 내용이 있는데, 이 부분은 내가 개념을 잘 몰라서 패스하고 그냥 설치했다.

여기까지 설정하면 설치는 끝나고, 그 뒤는 계정 만들고 저장소 생성해서 쓰면 된다. 

거의 3개월을 놀다가 와서 쓰는 거라 당시 작업이 잘 기억이 안 나지만, 설치 과정에서는 특별한 이슈가 없었던 것 같다. 설정 파일 접근하기 쉽게 /data/gitea 폴더에 마운트 걸어두는 것 정도?

