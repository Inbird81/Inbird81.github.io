---
title:  "Transformation.xaxis 함수의 설명 오류(추정)"

categories:
  - Sketchup SDK
tags:
  - [Sketchup SDK]

img_path: /images/
toc: false
toc_sticky: false

date: 2009-4-15
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2024년 현재의 환경과는 맞지 않을 수 있습니다._

Google에서 제공하는 Ruby SketchUp 온라인 메뉴얼의 `Transformation` 객체에는 `xaxis` 함수가 있다.

> [http://download.sketchup.com/OnlineDoc/gsu6_ruby/Docs/ruby-transformation.html#xaxis](http://download.sketchup.com/OnlineDoc/gsu6_ruby/Docs/ruby-transformation.html#xaxis)
 

이 함수를 보면 다음과 같이 적혀 있다.

>Return Value<br>
>point - a Point3d object containing the xaxis value
 
그런데, 아무래도 이 함수의 리턴값은 `Point3d`가 아니라 `Vector3d`인 듯 하다.
스케치업에서 Ogre3D 메쉬를 익스포트하는 스크립트 소스를 보면 다음과 같은 코드가 있다.

```ruby
.
.
mirrored = face[1].xaxis.cross(face[1].yaxis).dot(face[1].zaxis) < 0
.
.
```
 
이 소스는 실제로 에러 없이 동작한다. 즉, `xaxis`의 리턴값을 가지고 `cross`나 `dot`를 쓸 수 있다. `yaxis`나 `zaxis`도 마찬가지.

Ruby는 잘 모르기 때문에 어떻게 돌아가는 건지는 모르겠지만, 매뉴얼이 잘못되었거나 `Point3d`와 `Vector3d`가 호환되는 클래스이거나 둘 중 하나일 듯.