---
title:  "[Blog] Chirpy 블로그에 favicon 설정하기"

categories:
  - jekyll
tags:
  - [Blog]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-02-12
---

[Chirpy](https://chirpy.cotes.page/) 테마에 favicon을 설정하는 방법은 테마 자체 튜토리얼 페이지에 나와 있다.

> [Customize the Favicon](https://chirpy.cotes.page/posts/customize-the-favicon/)

전체적으로 이걸 따라하면 되지만, 따라하던 중 몇 가지 문제가 있었다.

첫째로, 내 로컬 프로젝트에는 assets 폴더가 없었다.

파비콘 경로는 `assets/img/favicons/`인데 아예 해당 폴더 자체가 없는 것.  
정확히는 `_site` 폴더 안에 있지만, 이 폴더는 생성된 사이트가 저장되는 곳이지 소스, 그러니까 원본 파일이 있는 곳이 아니다. git에서도 ignore되어 있고, 원본 저장소에도 해당 폴더는 없다.

추측이지만, [Chirpy Starter](https://github.com/cotes2020/chirpy-starter/generate)를 사용한 게 문제가 아닌가 싶다.

Chirpy 테마의 원본 저장소에는 assets 폴더가 있으므로, 이걸 fork하는 방식으로 설치했다면 없을 수가 없으니까. 이 경우 테마 내부의 라이브러리가 어디선가 디폴트 파일들을 가져와서 사이트를 빌드하는 것으로 추정된다.

그래서 해결법을 찾다가, 그냥 원본을 다운로드받은 후 assets 폴더를 프로젝트에 수동으로 집어넣어보니 정상적으로 동작했다.  
경로는 그냥 루트 아래고, [원본 저장소](https://github.com/cotes2020/jekyll-theme-chirpy)의 폴더 구조를 참고하면 된다.
<br><br>

두번째 문제는 원본의 사이즈였다.
Chirpy 테마는 512x512짜리 이미지를 사용한다고 되어 있는데, 내가 쓰려고 한 이미지는 그보다 작았다.

대체 512짜리 파비콘을 어디다 쓰는 건지는 모르겠지만 이 테마는 어쨌든 512를 쓰고, 파일이 없으면 빌드 단계에서 어디서 땡겨오기까지 한다.

일단 이 부분의 해결법은 `assets/img/favicons/site.webmanifest` 파일을 수정하는 것이다.

```shell
...
  "icons": [
    {
      "src": "{ favicon_path }/android-chrome-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "{ favicon_path }/android-chrome-384x384.png",
      "sizes": "384x384",
      "type": "image/png"
    }],
...
```
{:file="assets/img/favicons/site.webmanifest"}

원본은 이 부분에 512x512가 들어 있는데 자기 파일의 사이즈로 바꾸면 된다.  
`{ favicon_path }`의 중괄호는 정확하게는 두 개인데 블로그 테마 내에서 뭔가 오류로 인식하는지 중괄호 두 개를 쓰면 보이질 않는다. (마크다운 프리뷰에서는 정상으로 보임)  
이 문제는 해결법을 찾지 못해서 일단 그대로 둔다.

일단 로컬/깃허브 양쪽 모두 정상으로 보이지만, 보통 사이트는 384나 512짜리 파비콘 자체를 쓰지 않을 테니 제대로 해결된 건지는 모르겠다. 내 경우 자동생성되는 512짜리 이미지가 여전히 사이트에 포함되어 있고, 이것도 해결법을 찾지 못하고 있다.  
가능하다면 그냥 512짜리 파비콘을 만드는 게 가장 깔끔할 것 같다.

