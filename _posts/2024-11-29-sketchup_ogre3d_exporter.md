---
title:  "Ogre3D Sketchup Exporter 소스 분석"

categories:
  - Sketchup SDK
tags:
  - [Sketchup SDK]

img_path: /images/
toc: false
toc_sticky: false

date: 2008-11-10
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2024년 현재의 환경과는 맞지 않을 수 있습니다._

[Sketchup Ogre3D Exporter](/images/ogre_export.rb) 분석

OGRE Add-On Project의 일부.

Ruby Script로 제작.

>위키 소개: [http://www.ogre3d.org/wiki/index.php/Sketchup_Exporter](http://www.ogre3d.org/wiki/index.php/Sketchup_Exporter)<br><br>
>공식홈 소개: [http://www.ogre3d.org/index.php?option=com_content&task=view&id=17&Itemid=70](http://www.ogre3d.org/index.php?option=com_content&task=view&id=17&Itemid=70)

소스는 첨부파일에 포함. 오픈소스이므로 별 문제는 없을 듯.<br>

`Export()`, `exportDialog()`, `grabDialogData()`, `saveConfig()`는 따로 분석할만한 내용은 없다.<br>

핵심은 `collectMaterials()`함수. 여기서 정점, 재질 데이터 전부를 뽑고 `writeMaterials()`, `exportFaces()`에서 데이터를 XML 형태로 써넣는다.

일단 `collectMaterials(matlist, ents, trans, inherited_mat, root)`함수 분석.
 
- 인자 중 matlist는 메테리얼 리스트이다.<br> 하지만 이 코드에서는 matlist 내에 메테리얼 정보만이 아니라 면(face)과 , 변환(transform) 정보까지 포함시켜서 모든 데이터를 여기서 뽑아낸다.

- matlist는 배열이며, 배열의 각 요소는 다음과 같은 구조로 이루어진다.<br><br>
`[ handle, [ [face,trans,frontface, inherited_mat] ] ]`<br><br>
루비를 제대로 공부한 적이 없어서 분석이라기보다는 거의 찍기 수준이지만, 대강 C의 구조체 배열처럼 생각하면 될 듯. 제대로 루비 공부한 사람이 보면 비웃을 것 같다 -_-;<br>
  - 일단 handle와 배열 하나 해서 두 개의 인자를 가지는 구조체(C식으로 설명하자면)의 배열이 된다.
  - 두 번째 인자인 배열은 face,trans,frontface, inherited_mat의 4개 요소를 가지는 구조체의 배열이다. ([]가 두 겹으로 되어 있다는 데 유의해야 할 듯)<br>사실 루비를 제대로 공부한 게 아니라 거의 찍기 수준.

- ents는 엔터티 리스트.<br>

- trans는 변환값으로, 초기에는 변환이 없는 행렬이 들어간다.<br>

- inherited_mat는 계층관계에서 자신의 부모가 가진 메테리얼이다. SDK쪽에서 적어놨듯이 스케치업은 면 단위가 아니라 컴포넌트 단위로 재질을 입힐 수 있고, 이 경우 각 면은 자신이 속한 컴포넌트의 재질 정보를 계승받는다.<br>

- root는 아직 뭔지 정확히는 모르겠지만, 인스턴스일 경우 false로 처리하고, 내부적으로는 face 데이터를 뽑을지 말지를 결정하는 데 사용된다. 

다음은 함수 전체 소스.

```ruby 
def collectMaterials(matlist, ents, trans, inherited_mat, root)
  for e in ents      # 각각의 엔터티별로 루프를 돈다.
    case e
      when Sketchup::Face   # 엔터티가 면이라면
        if (not root) or OgreConfig.exportRootFaces # root 인자와 설정값에 따라
          if OgreConfig.exportFrontFaces # 전면의 정점을 뽑을 것인지
            if e.material # 재질 정보가 있는 경우.
                  mat = e.material
                  handle = @@tw.load(e,true)
                  # 위에 설명한 matlist의 구조에서 사용되는 handle값. collectFace() 참조.
              else
                  if inherited_mat    # 상위 구조에서 계승받은 메테리얼이 있을 경우
                      mat = inherited_mat[0]
                      handle = @@tw.load(inherited_mat[1],true)
                  else    # 아무것도 없을 경우
                      mat = nil
                      handle = 0
                  end
              end
              m = matlist[mat]
              collectFace(m, e, trans, handle, true, if mat then nil else inherited_mat end)
              # 이 함수는 나중에 설명
          end

          if OgreConfig.exportBackFaces # 후면의 정보도 전면과 방식은 똑같다.
            if e.back_material
                mat = e.back_material
                handle = @@tw.load(e,false)
            else
                if inherited_mat
                    mat = inherited_mat[0]
                    handle = @@tw.load(inherited_mat[1],false)
                else
                    mat = nil
                    handle = 0
                end
            end
            m = matlist[mat]
            collectFace(m, e, trans, handle, false, if mat then nil else inherited_mat end)
          end
        end
      when Sketchup::Group
        # 그룹일 경우 재귀호출을 통해서 그룹에 속한 각각의 엔터티에 대해 함수를 수행한다.
        # trans에 현재 그룹의 위치 정보가 더해진다.
        # 현재 그룹에 메테리얼이 있으면 inherited_mat에 추가한다. 메테리얼, 엔터티, 변환 정보가 포함되는 듯.
        collectMaterials(matlist, e.entities, trans*e.transformation, if e.material then [e.material,e,e.transformation] else inherited_mat end, root)
      when Sketchup::ComponentInstance
        # 인스턴스일 경우 해당 컴포넌트의 원본(definition)에 속한 각각의 엔터티에 대해 함수 재귀호출. 그 외의 것은 그룹의 경우와 같다.
        collectMaterials(matlist, e.definition.entities, trans*e.transformation, if e.material then [e.material,e,e.transformation] else inherited_mat end, false)
    end
  end
end
```    