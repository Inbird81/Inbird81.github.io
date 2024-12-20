---
title:  "Sketchup SDK 현재까지 확인된 문제점들"

categories:
  - Sketchup SDK
tags:
  - [Sketchup SDK]

img_path: /images/
toc: false
toc_sticky: false

date: 2008-11-6
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2024년 현재의 환경과는 맞지 않을 수 있습니다._

1. 스케치업에서 컴포넌트를 생성했을 때, 화면상에 있는 모든 컴포넌트 인스턴스를 삭제해도 컴포넌트 정의는 남아서 파일에 저장된다.<br>즉, 도큐먼트 객체에서 `GetComponentDefinitions()`로 얻어온 리스트에는 실제 화면에 출력되지 않는 컴포넌트의 정보도 들어가 있는 것이다. 특히 Bryce(스케치업을 맨 처음 실행하면 보이는 사람 그림. 컴포넌트다)는 무슨 짓을 해도 skp 파일에 저장된다. 니가 바퀴벌레냐 -_-;<br>
 이 문제를 해결하기 위해서는, `GetComponentDefinitions()`를 쓰지 않고 전체 컴포넌트 인스턴스를 검색하면서 각각의 Definition에 대한 참조를 검색, 중복이 없도록 리스트를 직접 만드는 방법밖에 없다. 아래 포스팅에서 `ReadGeometryMain()`의 코드에 있는 `AddComponentDefinition(pInstance->ComponentDefinition);` 가 그 역할을 수행한다. 이 함수는 그냥 ID로 중복체크 후 전역 변수로 선언된 리스트에 컴포넌트 정의 객체를 추가하는 역할을 한다.<br>
<br>
2. 스케치업에서는 원본이 같은 컴포넌트(즉, 인스턴싱된 컴포넌트. 스케치업에서는 컴포넌트를 복사하면 인스턴스를 생성하는 것이 기본이고, Make Unique 명령으로 독립된 컴포넌트로 만들 수 있다) 에 각각 다른 메테리얼을 입힐 수 있다.<br>
..<br>
...<br>
??????<br><br>
그럴 수도 있다고 치자. 그럼 각각의 인스턴스는 자신의 정의와 별도로 각 정점에 대한 텍스쳐 좌표 정보를 가지고 있어야 한다는 건데? 그게 무슨 인스턴스냐? -_-;;;;<br>
텍스쳐 좌표 정보를 뽑아내는 작업은 UVHelper라는 객체가 담당하기 때문에 실제로 어떤 구조로 되어 있는지는 모르겠지만, 졸라 난감하다. 이런 식이 되면, 원본 정보를 두고 각 인스턴스가 원본을 참조하기만 하는 구조는 불가능하다. 그래서 Skp를 다른 3D 확장자로 익스포트하면 인스턴스 구조를 보존하지 않는 건가.. -_-;<br>
맥스의 인스턴스와 비슷할지도 모르지만, 스케치업의 Max 익스포터는 아직 구하질 못해서 이 구조를 그대로 가져갈 수 있는지 모르겠다.<br>
어쨌든 회사에서 쓸 DB의 구조에 맞출 수 있을 것 같지도 않고(모델링 툴로 스케치업 하나만 쓰는 게 아니니까), 인스턴스 구조는 포기해야 할지도.<br>
<br>
3. 프로젝트의 요구사항을 생각해보면 컴포넌트/그룹의 이름과 계층구조, 인스턴스 구조를 그대로 유지하는 Max 익스포터가 필요한데, 아무래도 그런 건 없을 것 같다… -_-;

