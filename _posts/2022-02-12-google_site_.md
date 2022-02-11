---
title:  "[Google] Google Site Verification 및 Sitemap"

categories:
  - etc
tags:
  - [Blog]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-02-12
---
Chirpy 테마의 `_config.yml`파일을 설정하다 보니 `google_site_verification`라는 항목이 있었다.

웹 쪽은 php랑 asp 문법만 아는 원시인에게 또 처음 들어보는 용어가 튀어나와서, 오늘도 구글링을 해야 했다.

> <https://support.google.com/webmasters/answer/9008080?hl=ko>

구글에서 검색엔진 최적화를 위해 사이트의 소유권을 확인하는 코드라는 모양이다.

코드를 가져오는 방법은 다음 포스트를 참고했다.

> <https://vine.co.kr/208>

HTML 태그를 선택하면 나오는 코드를 `_config.yml`의 해당 항목에 추가하면 된다.  
이 때 구글 서치 콘솔 쪽에서 '확인'을 누르면 등록된 코드를 검증하므로, 먼저 코드를 추가하고 push해서 서버에 반영한 후 확인 버튼을 눌러야 한다.

구글 서치 콘솔에서는 사이트맵도 등록할 수 있고, chirpy 테마는 사이트맵도 자동생성하므로 하는 김에 등록하기로 했다.

하지만...

![ㅁㄴㅇㄹ](2022_02_12_1.PNG)
_안 된다_

찾아보니 이 문제로 고통받는 사람이 한둘이 아닌지 관련글이 많았지만, 이것저것 다 따라해봐도 소용없었다. 사이트맵 파일 검증을 돌려봐도 정상이고, URL 검증도 통과되고.

최대 2~3일까지 걸린다는 말이 있으니 일단 지켜봐야 할 것 같다.

