---
title:  "[Jekyll] Synology Nas에서 jekyll 사용하기"
excerpt: "Synology Nas의 Docker를 이용해 jekyll를 설치하고 사용하는 방법"

categories:
  - Diary
tags:
  - [Blog, jekyll, Synology]

toc: true
toc_sticky: true
 
date: 2022-02-11
last_modified_at: 2022-02-12
---

Github 블로그는 위지윅(WYSIWYG)에디터를 지원하지 않기 때문에 포스팅을 등록해야 실제 블로그에서 어떻게 보이는지를 알 수 있다.

그럼 미리보기는 어떻게 하는가?

일단 마크다운(markdown) 문법 자체는 미리보기를 지원해주는 에디터가 많이 있다. 내 경우는 `Visual Studio Code`를 이용하고 있다.
VS Code에는 마크다운 미리보기를 지원하는 애드온(정확히는 extensions라고 부름)이 있는데, 2022년 2월 현재 사용하는 버전에는 자체적으로도 미리보기가 지원되는 것 같다.

<img width="290" alt="blog-2022-09-09-1" src="https://user-images.githubusercontent.com/99251258/153610279-c1b71039-a449-46d9-9629-1d20b560922a.PNG">  

미리보기를 지원해주는 방식에 조금 차이가 있는 것 같아서 내 경우 둘을 번갈아 쓰고 있다. 

하지만 이건 어디까지나 '마크다운 문법'미리보기지, 블로그에서 이 글이 어떻게 보이는지를 정확히 알려주는 게 아니다.

그럼 그래서 블로그 미리보기는 어떻게 하는가?

**로컬에 Jekyll 서버를 띄우고 거기서 보면 된다.**

Ruby와 Jekyll, 블로그 테마 등이 모두 설치되어 있다면 Windows PowerShell이나 Command Prompt에서 블로그 프로젝트의 루트 폴더로 가서 `bundle exec jekyll serve`라고 치면 로컬 서버가 시작되고, cmd를 켜놓은 상태로 http://127.0.0.1:4000에서 내 블로그를 볼 수 있다.  

...매우 귀찮다.

실행이야 배치파일을 만들든 뭐든 하면 되겠지만, 로컬 서버를 매번 띄우는 것 자체부터가 귀찮은 일이다.

그리고 결정적으로, 내가 사용하는 [Chirpy](https://chirpy.cotes.page/) 테마가 문제를 일으켰다.

블로그 설치까지는 되는데, 포스트를 올리면 계속해서 로컬에서 에러를 내는 것이었다.

정작 깃허브에 올리면 정상 동작하는데, 로컬에서만 에러가 발생하고 원인도 알 수가 없었다.

내가 뭐 Ruby를 알아서 디버깅할 수도 없고, 로컬에서만 에러가 난다는 점과 에러 로그로 볼 때 windows 환경에서 파일명이나 경로를 읽어오는 과정에서 뭔가 꼬였을 거라는 추측만 할 수 있었다.

그럼 윈도우 환경인 로컬이 아닌 다른 곳에 jekyll 서버를 띄우면?  
아예 상시로 돌아가는 자체 서버가 하나 있는 셈이니 편하지 않을까?

마침 쓰고 있는 Synology Nas에 이걸 깔 수 있나 하고 봤더니, 역시나 가능했다.

>[Synology nas에서 docker를 이용한 jekyll 사용하기](https://blog.actin.kr/devlog/2019/08/14/synology-docker-jekyll/)

설치법은 이 포스팅을 보고 따라했고, 여기서 차이가 있는 부분만 정리한다.  

*****

### 1. 설치 폴더 생성.
먼저, NAS 공유폴더 내에 블로그를 둘 폴더를 생성해야 한다.

위 포스팅에서는 `jekyll_home`로 했는데, 이름이나 위치는 어디든 상관없다.

`jekyll_home/vendor/bundle`는 라이브러리 등이 설치되는 경로 같은데, 역시 이름이나 위치는 상관없다. 블로그 홈 폴더 아래가 아니라도 된다.

### 2. Docker에서 Jekyll 설치
위의 강좌를 순서대로 따라하면 맨 처음 커맨드라인 명령어를 실행하는 단계에서 jekyll이 설치되어 버린다. 내 경우는 결과적으로 버전이 다른 jekyll 두 개가 설치되어 버렸다.  
위 포스팅에서 설치하는 jekyll의 버전은 3.8.6인데 2022년 2월 현재 jekyll의 버전은 그보다 높으므로 일단 패스하고 Docker에서 설치부터 진행한다.

이미지 다운로드나 컨테이너 생성 부분은 위 포스팅을 따라가면 된다. 다만 볼륨 추가 부분에서 설치 폴더를 다르게 지정했다면, 지정해놓은 경로를 `/usr/local/bundle`와 `/srv/jekyll`의 마운트 경로에 입력해야 한다.

그 다음 포트 설정에서 로컬 포트를 지정해준다.  
4000번이 실행된 사이트에 접속할 때 사용하는 포트다.   
<img width="316" alt="port setting" src="https://user-images.githubusercontent.com/99251258/153615728-94c22c67-0937-4c3c-9cc9-7c834cfbc596.PNG">

그리고 마지막 탭인 환경 부분에서 아래와 같이 설정한다.

<img width="322" alt="config" src="https://user-images.githubusercontent.com/99251258/153616756-0207a7a2-dbac-442c-b4a3-a709cac1774d.PNG">

TZ는 타임존(Timezone) 설정이다. 설명은 아래 게시물 참고.

> [[github blog] 한국 시간대로 time zone 세팅하기](https://smelting.tistory.com/m/17)

그리고 맨 아래의 명령에는 `jekyll serve`나 `jekyll s`를 넣어야 한다.  
참고한 포스팅에서는 `jekyll build -w`로 되어 있는데, 이렇게 하면 사이트가 빌드만 되고 서버가 실행되지 않는다.

문제는 시놀로지 NAS의 도커 설정에는 이 명령 부분을 바꾸는 곳이 없어서, 한번 설치하고 나면 수정할 수가 없다. 내가 못 찾은 걸수도 있지만, 나는 결국 이것 때문에 jekyll을 한번 지우고 새로 설치해야 했다.

경로 설정이 되어 있고 해당 경로에 블로그 테마가 설치되어 있었다면 컨테이너가 실행되면서 바로 블로그를 빌드한다.

하지만 블로그 테마에 따라 젬(Gem; Ruby의 라이브러리)을 다운받거나 해야 하는 경우가 있을 수 있다. 이건 케바케고 나도 잘 모르는 영역이지만, 어쨌든 빌드했는데 Gemfile 어쩌고 하면서 실행이 안 된다면 다음 명령을 실행해보자.

```bash
docker run --rm \
  --volume="/volume1/[마운트 경로]:/srv/jekyll" \
  --volume="/volume1/[마운트 경로]:/usr/local/bundle" \
  -it jekyll/jekyll:latest \
  bundle update
```

먼저 시놀로지 NAS의 ssh 접속을 활성화하고, ssh로 접속한 후 거기서 명령을 붙여넣으면 된다.

다만 docker의 실행권한이 없을 수 있으므로, 권한이 없다고 나오면 관리자 계정으로 접속해서 `sudo -i`를 쳐서 슈퍼유저 권한을 가져와야 한다.

### 3. 실행
브라우저에서 NAS에 4000번 포트로 접속해보면 블로그가 뜨는 것을 확인할 수 있다.

도커 컨테이너의 로그나 터미널 출력을 확인하면 정상동작하는지, 어떤 에러가 뜨는지 볼 수 있다.

<img width="438" alt="log" src="https://user-images.githubusercontent.com/99251258/153619925-5bb153bf-5e3b-4553-a3a6-92b96318787c.PNG">  

위는 정상적으로 서버가 실행되었을 때의 로그다.
<br><br>

솔직히 리눅스나 루비나 docker는 잘 몰라서 그냥 장님 코끼리 만지듯 강좌 보고 따라한 거고, 그래서 해놓고도 잘 모르는 부분이 많다. 여기까지 공부할 시간도 없고.

그래도 기록을 남겨두면 나중에 까먹었을 때 도움은 되겠지.

