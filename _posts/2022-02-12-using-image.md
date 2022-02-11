---
title:  "[Github] Github Blog에 이미지 올리는 방법들 정리"

categories:
  - etc
tags:
  - [Blog]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-02-12
---

Github blog를 쓰면 불편한 게 한둘이 아니지만 그 중에서 특히 신경쓰인 건 이미지 추가였다.

블로그 자체적으로 이미지 업로드를 지원하는 게 아니니, 어딘가에 이미지를 따로 업로드하고 링크해야 한다.

그리고 코딩이 다 그렇듯 방법은 여러 가지가 있다.  

*****
### Github Issue 사용
깃허브의 Issue에 이미지를 업로드하고 링크해서 쓰는 편법(?)이다.
검색하면 금방 찾을 수 있는 것이므로 따로 설명하진 않는다.

> [[Github 블로그] 이미지 아주 쉽게 삽입하기](https://ansohxxn.github.io/blog/insert-image/)

로컬 PC의 이미지를 Issue창에 드래그하면 마찬가지로 업로드된다.

***
### Github repository content 사용

> [[Github] Github를 데이터 저장소처럼 활용해보자](https://ninja86.github.io/2019/05/24/1.html)

Github 저장소의 파일을 다음과 같은 경로 구조로 가져올 수 있다.

`https://raw.githubusercontent.com/:owner/:repo/:branch/:file_path`

내가 사용하고 있는 chirpy 테마의 개발자는 블로그 이미지용으로 별도의 저장소를 만들어 쓰고 있는 것 같다. 

블로그 이미지용 저장소를 별도로 만드는 것과, 그냥 기존 블로그 저장소에 이미지용 폴더를 추가하는 것 중 뭐가 더 나은 방법인지는 잘 모르겠다.

***
### 그냥 블로그에 포함시키기
이것저것 따질 거 없이 그냥 블로그 프로젝트 자체에 포함시킨 후 포스트랑 같이 commit해버리면 안 되나?

![된다](boo.gif)

일단 로컬에서는 되는 것을 확인했다. 이대로 push했을 때 github에서도 정상동작하는지 여부는 확인할 필요가 있다.

