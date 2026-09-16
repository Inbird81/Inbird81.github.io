---
title:  "TextMeshPro에서 한글, 일본어, 중국어 asset 생성하기"

categories: [Unity]
tags:
  - [Unity, Testmeshpro]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2024-10-13
---
_* 이전 게시물 : 이 게시물은 2024년에 작성된 것으로, 2026년 현재의 환경과는 맞지 않을 수 있습니다._<br>
예전에 정리하다가 완성하지 못하고 버려둔 포스팅이라 내용은 별 거 없고 거의 참고자료 정리에 가깝다.
<hr>

ttf나 otf 파일을 그냥 추가한 다음 끌어다 쓰기만 하면 되는 기존 `UI Text`와는 달리, `TextMeshpro`는 내장된 `Asset Creator`라는 툴을 이용해서 ttf 파일에서 폰트 아틀라스를 생성하는 과정을 거쳐야 한다.<br>
영어권 사용자들이야 글자수가 몇 개 안 되니까 아틀라스를 만드는 게 부담이 안 되는데, 한국이나 중국, 일본어는 사용하는 글자수가 많다 보니 아틀라스 만드는 것부터가 일이다.<br>
직접 해보면 만드는 것도 불편하고 이걸로 텍스트를 다루는 것도 기존 `UI Text`에 비해 불편하기 그지없어서, `TextMeshpro`에서만 지원하는 기능(외각선 효과 등)을 써야 하는 경우가 아니면 별로 쓰고 싶지 않다.<br>

어쨌든 일반적으로 한글 아틀라스는 `Asset Creator`에서 `Custom Range`를 선택하고 한글의 유니코드 범위를 지정하는 식으로 사용한다.<br>
검색으로 찾아본 것 중에는 `32-126,44032-55203,12593-12643,8200-9900`이 가장 일반적으로 사용되는 것 같다. `32-126`은 영문 범위, `8200-9900`은 특수문자 범위다.

> [유니티 TextMeshPro 어셋 폰트 추가하는 방법](https://lioicreim.tistory.com/222)

그 외에 일본어와 한자의 코드범위는 다음 링크에서 확인 가능하다.

> [유니코드 한글, 한자, 일어 범위](https://aniz.tistory.com/328)
> [Wikipedia 유니코드 페이지](https://ko.wikipedia.org/wiki/%EC%9C%A0%EB%8B%88%EC%BD%94%EB%93%9C_%EC%98%81%EC%97%AD)

문제는 이대로 해보면 한글만 11000자가 넘기 때문에 아틀라스가 너무 커지고, 여기에 일본어나 중국어까지 지원하려고 하면 4096*4096 아틀라스로도 턱없이 모자란다는 것이다.<br>
일본어 히라카나/카타카나는 글자수가 많지 않지만, 한자의 경우 한중일 통합한자 + 통합한자 확장 A의 범위만으로도 3만자에 가깝기 때문에 이걸 아틀라스 한 장에 다 넣는 건 무리다.

[Table of General Standard Chinese Characters](https://discussions.unity.com/t/table-of-general-standard-chinese-characters/715835)

[Creating asset from font with a lot of characters](https://discussions.unity.com/t/creating-asset-from-font-with-a-lot-of-characters/708290)

[Chinese font problems](https://discussions.unity.com/t/chinese-font-problems/679971)

위의 포럼 글에 있는 한중일 폰트 만드는 요령을 정리하면 다음과 같다.

- 표준한자 8천자를 사용.
- 언어별로 폰트를 만든 후 fallback으로 연결
- 한국어, 중국어, 일본어 폰트는 다 따로 만들고 그냥 사용하는 언어에 맞춰 폰트를 바꾸도록 하는 것이 좋음.<br>
 중국어는 간체/번체가 있고 일본어는 신자체라고 따로 쓰기 때문에 어차피 분리해야 함.<br>
 `I2 Localization`같은 번역툴은 언어별로 폰트를 따로 지정하는 기능이 있음.

> [한중일의 한자 차이.jpg](https://www.clien.net/service/board/park/15782827)

한글 필수한자를 뽑기 위한 리스트.

>[KS-1001 한글 2350자 + 특수문자 영문](https://mentum.tistory.com/133)

한국어에서 사용하는 한자도 어느 정도 제한되어 있지만(예를 들어 네이버 나눔고딕에는 한자가 2천자만 들어 있다), 어차피 한자표기를 병기하는 경우는 무협처럼 복잡한 한자를 써야 하는 경우일 가능성이 높으므로 한국어-중국어 번체의 폰트를 통일하고 fallback으로 연결하는 게 좋아 보임.

일본어는 고유한 특수문자(전용의 마침표나 쉼표 문자 등이 있다)와 사용하는 한자 목록이 있다.

>[japanese_full.txt](https://gist.github.com/kgsi/ed2f1c5696a2211c1fd1e1e198c96ee4#file-japanese_full-txt)


중국어/일본어를 지원하는 폰트에 대한 정보는 다음과 같다.

[외국어 지원 폰트확인하기](https://www.bizhows.com/cms/help_center/%EC%99%B8%EA%B5%AD%EC%96%B4-%EC%A7%80%EC%9B%90-%ED%8F%B0%ED%8A%B8%ED%99%95%EC%9D%B8%ED%95%98%EA%B8%B0/)

무료로 사용가능하며 중국어 간체/번체를 모두 지원하는 폰트로는 구글에서 공개한 `Noto Sans`와 어도비에서 공개한 `Source Han Sans`가 있다. 이 폰트는 구글/어도비 합작으로 제작했으며 실질적으로 같은 폰트라는 모양.

> [Noto Fonts](https://fonts.google.com/noto/fonts)
> [Source Han Sans](https://github.com/adobe-fonts/source-han-sans)
