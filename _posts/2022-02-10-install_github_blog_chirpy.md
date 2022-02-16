---
title:  "[Jekyll] Windows 10 환경에서 Github 블로그 설치"
excerpt: "Windows 10 환경에서 Github 블로그와 Chirpy 테마 설치"

categories:
  - Jekyll
tags:
  - [Blog, jekyll]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-02-12
---

원래는 이 글이 먼저 올라왔어야 했는데, 쓰던 글을 옮기다가 날려먹어서 복구가 늦어졌다 OTL

Github 블로그는 일반적으로 생각하는 서비스형 블로그와는 기본 개념 자체가 다르다. 설치도 손이 많이 갈 뿐더러 '개발 환경'을 깔아야 하는 등 코딩을 모르는 사람이 하기에는 불편한 부분이 많이 있다.

사실 설치 방법도 잘 정리된 글이 많지만, 그것들을 보고 따라하면서도 내 환경과 맞지 않아서 고생한 부분이 있었고, 그런 것들을 정리해두는 건 의미가 있을 것이다. ~~이걸 깔다가 이틀간 개고생한 게 억울해서라도 적어놔야겠다~~

## Github 블로그의 기본기념

역시 잘 정리된 글이 많으므로, 간략하게만 정리한다.

> [GitHub Pages 블로그 소개](https://devinlife.com/howto%20github%20pages/github-blog-intro/)

통상적인 서비스형 블로그는 유저가 글을 올리면 서버측에서 실시간으로 그 글을 블로그 사이트, 즉 html 형태로 출력해준다.
이렇게 사용자의 입력에 반응하고 상호작용하는 사이트의 페이지를 동적 웹 페이지(Dynamic Web Page)라고 부른다. 여기에 쓰이는 게 php니 asp니 하는 것들이고.

하지만 깃허브 블로그는 이 작업을 로컬에서 진행한다.
글을 쓰고, 그것을 로컬에서 빌드해서 결과물인 html 페이지를 만든 후, 그 html 페이지를 서버에 업로드한다.
이렇게 만들어진 html 페이지는 그냥 결과물을 출력할 뿐, 그 자체로는 사용자의 입력에 반응할 수 없다(Javascriprt 같은 건 동작하지만 이건 서버단에서 처리하는 게 아니라 이야기가 조금 다르다)
이를 정적 웹 페이지(Static Web Page)라고 부른다.

깃허브 블로그의 기본 개념은 로컬에서 빌드한 정적 웹페이지를 git으로 서버와 동기화시켜서 웹사이트를 서비스하는 것이다.

어차피 git이 하는 역할이 그거니까 이걸 ftp처럼 업로드/동기화 툴로 사용해서 로컬에서 빌드한 웹페이지를 그냥 서버에 올린다. 서버는 복잡하게 php니 mysql이니 하는 걸 깔지 않아도 되므로 부담이 줄고, 이는 호스팅 비용의 절감으로 이어진다.

콜롬부스도 달걀을 탁 치며 감탄할 발상의 전환이다. 대체 어떤 미치광이가 이런 생각을 해냈는지 모르겠다.

분명히 프로그래머의 관점에서는 합리적이고 장점이 여러 가지 있는 아이디어다.

하지만 이걸 프로그래머가 아닌 사람에게 어떻게 설명할지를 묻는다면, 솔직히 못하겠다. 

동적 웹사이트가 뭐 대단한 기술도 아니고 서비하는 업체도 넘쳐나는데, 그냥 골라 쓰면 되잖아? 왜 굳이 귀찮게 자기 PC에서 그 짓을 해야 하는가?  
프로그래머가 아닌 일반인은 그렇게 생각하는 게 정상이고, 그게 맞다. 이런 게 멋지다고 생각하는 프로그래머가 이상한 외계인이지.

다시 말하지만 이건 프로그래머 관점에서만 멋져 보이는 발상이다. 그나마도 자기가 블로그를 세부적으로 커스터마이징할 게 아니면 '멋지다/쿨하다' 외의 장점은 아무것도 없다.  
당연히, 프로그래머가 아닌 사람에게는 널린 좋은 블로그 서비스를 두고 깃허브 블로그를 골라서 얻는 장점은 아무것도 없고, 고생만 끝없이 늘어난다. 그러니까 괜히 ~~나처럼~~ 남들 한다고 따라하지 말자.

## 로컬 개발 환경 설치

깃허브 블로그는 Jekyll이라는 Ruby 언어 기반의 정적 웹사이트 생성기를 사용한다.

이걸 로컬에 깔지 않고도 깃허브에서 지원하는 서비스만으로 블로그를 만들 수는 있지만, 그러면 테마(블로그 스킨)의 선택폭도 줄어들고 할 수 있는 일에도 제약이 꽤 생긴다.

일단 깃허브 블로그를 쓰는 사람들이 다 개발자다보니, 로컬 개발 환경을 안 깔고 쓴다는 걸 애초에 전제하질 않는 것 같다.

블로그 하나 만드는 데 개발환경 구축까지 하기 싫어서 우회 방법을 찾아봤지만, 최종 결론은 블로그 운영까지 감안하면 그냥 얌젼히 시키는 대로 다 깔아놓는 게 낫다는 것이었다.

블로그 설치 방법에 대해서 참고한 것은 아래의 강좌들이다.

> [[Github 블로그] 깃허브(Github) 블로그를 생성해 보자](https://ansohxxn.github.io/blog/i-made-my-blog/)

> [GitHub Pages 블로그 준비하기](https://devinlife.com/howto%20github%20pages/github-prepare/)

대부분의 작업은 그냥 위 블로그 게시물을 따라하면 되고, 그 중 내가 다르게 처리한 것들만 정리한다.

- 깃허브 블로그를 위한 Repository를 생성 후 로컬에 가져오는(clone) 작업은 그냥 자기가 편한 방법으로 하면 된다. 내 경우 SourceTree를 사용하므로, 그냥 소스트리를 이용해 저장소를 가져왔다.

- 윈도우 환경에서 Ruby 설치는 어려울 게 없다. 그냥 <https://rubyinstaller.org/downloads/>에 들어가서 개발환경을 포함(With Devkit)이라고 적힌 리스트에서 추천 버전을 다운받으면 된다.  

![추천 버전](https://user-images.githubusercontent.com/99251258/153360633-f106526e-4eea-4ab8-a53d-54ccc0fdc131.PNG)
_옆에 =>라고 표시된 게 추천 버전이다._  
설치는 'Add Ruby executables to your PATH' 옵션이 체크되었는지만 확인하고(버전에 따라 다를 수 있지만, 내 경우는 디폴트로 체크되어 있었다) 그냥 Next 버튼을 연타하면 된다.

## 블로그 테마 설치
github 블로그는 일반적으로 jekyll 테마를 가져와서 사용한다. 백지에서부터 자기가 블로그 코드를 짤 수야 있겠지만 굳이 바퀴를 새로 발명하는 건 시간낭비다.

블로그 설치 강좌를 찾아보면 [minimal mistakes 테마](https://mmistakes.github.io/minimal-mistakes/)를 많이 쓰는 것 같다. 

다만 내 경우는 커스터마이징에 공을 들일 시간도 능력도 없어서, 그냥 완성품으로 마음에 드는 디자인을 가진 [Chirpy 테마](https://chirpy.cotes.page/)를 골랐다.

jekyll 테마는 실질적으로 코드 프로젝트기 때문에 케바케인 부분이 많은데, 그걸 모르고 괜히 남들 안 쓰는 테마 가져다 쓰는 바람에 꽤 고생을 했다.

Chirpy 테마의 설치 방법은 아래 링크에 정리되어 있다.

> [Getting Started](https://chirpy.cotes.page/posts/getting-started/)

내 경우는 **[Chirpy Starter](https://github.com/cotes2020/chirpy-starter/generate)**를 이용해 설치했고, 이 경우 Ruby와 Jekyll가 설치되어 있다는 전제하에 절차는 간단하다.

1. Chirpy Starter로 블로그 테마를 자기 github 블로그에 가져온 후 로컬에 clone한다.

2. 커맨드 프롬포트(혹은 powershell 등)로 로컬 블로그 프로젝트 루트 폴더에 접속해 `bundle`이라고 입력한다.  
그렇게 하면 jekyll이 테마에 미리 설정되어 있는 라이브러리(Gem)들을 알아서 다운받아 추가한다.

3. `bundle exec jekyll s`를 입력하면 로컬 서버가 실행되고 `127.0.0.1:4000`에서 볼 수 있다.  
이때 실행 후 커맨드 프롬포트 창은 닫지 않고 놔둬야 한다.

여기까지만 하면 일단 로컬에서 블로그 테마가 돌아가는 것은 확인할 수 있다.

내 경우는 로컬에서 포스팅에 문제가 있어서 [Synology NAS에 Jekyll을 설치](/posts/install-jelyll-Synology-nas/)해서 로컬 테스트 서버같은 느낌으로 쓰고 있다.

## 테마 설정과 업로드

테마의 기본적인 설정은 `_config.yml`파일에서 다룬다.  
설정하면서 이슈가 있었던 부분들은 별도의 포스팅으로 정리했다.

일단 Windows 환경에서는 [Getting Started](https://chirpy.cotes.page/posts/getting-started/) 문서에 적힌 대로 커맨드 프롬포트상에서 다음을 입력해야 한다.

```console
bundle lock --add-platform x86_64-linux
```
빼먹으면 깃허브에서 빌드가 에러난다.

로컬에서 블로그가 제대로 동작하고 [글쓰기](https://chirpy.cotes.page/posts/write-a-new-post/)까지 제대로 된다면 `Gemfile.lock` 파일이 생성되었는지 확인하고 commit한 후 깃허브에 push한다.  
그러면 테마에 설정되어 있는 [Github Action](https://github.com/features/actions)이 자동으로 트리거되며 서버상에서 홈페이지를 빌드한다.  
깃허브 액션에 대해서는 다음 게시물 참고. 

> [Github Action 사용법 정리](https://zzsza.github.io/development/2020/06/06/github-action/)

처음 푸시하면 서버도 라이브러리 설치하느라 몇 분 걸린다. 진행상황은 자기 저장소의 Actions 탭에서 볼 수 있다.

![Actions](2022_02_12_2.PNG)

여기서 작업의 성공/실패 여부와 로그도 볼 수 있으므로 오류가 발생할 경우 참고하면 된다.

내 경우 플랫폼 추가 명령을 입력할 때 liunx를 linux로 잘못 쳐서 서버에서 에러가 나는 걸 못 찾아서 한 시간 넘게 고생했다. 멍청하면 몸이 고생이지...OTL

액션이 완료되면 블로그를 서버에서 확인할 수 있다.

설치할 때는 아무것도 몰라서 헤매느라 고생했는데, 정리하고 보니 별 거 없어 보인다. 역시 잘 모르면 몸이 고생이지 뭐.

