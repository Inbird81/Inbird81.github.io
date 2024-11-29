---
title:  "SketchUp SDK에서 메테리얼의 이름 얻기"

categories:
  - Sketchup SDK
tags:
  - [Sketchup SDK]

img_path: /images/
toc: false
toc_sticky: false

date: 2009-4-22
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2024년 현재의 환경과는 맞지 않을 수 있습니다._

스케치업 루비스크립트의 `Material` 클래스에는 `name`과 `display_name` 두 개의 메소드가 있다.


이 중 `name`는 메테리얼의 실제 이름, 즉 내부에서 사용되는 이름을 불러오는 것이고 `display_name`은 스케치업의 UI에 보이는 이름을 가져온다.


스케치업에서 'Material1'이라는 메테리얼(자동으로 생성되는 이름)이 있을 때, `display_name`는 보이는 그대로 'Material1'을 리턴하지만 `name`는 '*1'을 리턴한다. 내부에서는 저런 식으로 사용되는 듯.

문제는, Sketchup 6 C++ SDK에는 `display_name`에 해당하는 함수가 없다 -_-;;

그래서 그냥 `Material.GetName()`으로 실제 이름을 끌어다 쓰는데, 다행이도 메테리얼명에 `*`가 들어가도 오거에서 사용하는 데는 별 문제가 없는 듯.