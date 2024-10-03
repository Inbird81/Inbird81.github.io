---
title:  "SkpApplication()의 생성"

categories:
  - Sketchup SDK
tags:
  - [Sketchup SDK]

img_path: /images/
toc: false
toc_sticky: false

date: 2008-11-5
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2024년 현재의 환경과는 맞지 않을 수 있습니다._

스케치업 익스포터 dll을 만드는 경우야 형식(아마도 DoExport()함수인 듯)만 맞춰주면 skp 파일을 읽어들이거나 하는 일은 스케치업 자체에서 해 주겠지만, 다른 응용 프로그램에서 스케치업 파일을 읽거나 생성하려면 먼저 파일을 불러오고 skp 파일 객체를 생성하는 것이 첫번째이다.

스케치업 파일을 읽고 객체를 생성하는 데 관련된 클래스는 다음과 같다.

> ISkpAppliaction : skp 어플리케이션 객체. 도큐먼트 객체를 호출할 수 있다.<br>
> ISkpDocument : 실제 파일 내의 데이터를 담고 있는 객체.<br>
> ISkpFileReader : skp 파일을 읽어서 도큐먼트 객체를 생성하는 리더 클래스.

ISkpAppliaction와 ISkpFileReader는 API 도큐먼트에는 나와 있지 않지만(..) 같은 클래스의 인터페이스로 추정된다. 즉, 어플리케이션 객체를 생성하면 파일을 읽을 수 있는 셈인데..

**API 도큐먼트 어디에도 이 객체를 직접 생성하는 방법에 대한 설명이 없다 -_-;;;;**

exporter dll을 만들 때는 객체를 직접 생성할 필요가 없긴 한데, 분명히 이 SDK는 외부 어플리케이션에서 skp 파일을 읽어들이거나 생성할 때 쓰는 거라고 SDK 소개에 적혀 있다. 대체 어쩌라는겨? (뭐, 내가 능력이 부족해서 못 찾아냈을수도 있지만)

현재까지 알아낸 SkpApplication 객체 생성 방법은 두 가지다.

1. SDK 예제 중 하나에 들어 있는 SkpWriter.dll을 호출해서 그 안에 있는 GetSkpApplication() 함수를 쓰는 방법이다.<br>
2. SDK 예제 중 하나에 들어 있는 SketchUpReader.dll을 호출해서 그 안에 있는 GetSketchUpSkpApplication() 함수를 쓰는 방법이다.

**… 저 둘, 차이가 뭐야?**

둘 다 예제 소스만 있고(게다가 ***주석도 없다***. 너희들 구글에서 만든 거 맞니?) 다른 설명이 없어서 저 둘 사이에 무슨 차이가 있는지 알 방법이 없다.
결국 고민 끝에 SketchUpReader.dll을 쓰기로 결정.
어찌어찌 컨버터는 돌아가고 있지만, 정말 괜찮은 걸까…?