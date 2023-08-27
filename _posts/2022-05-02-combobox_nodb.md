---
title:  "C# ComboBox의 SelectedValue DB 없이 사용하는 법."

categories:
  - C&#35;
tags:
  - [C&#35;]

img_path: /images/
toc: false
toc_sticky: false

date: 2010-1-8
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

C# ComboBox에는 텍스트-값 쌍을 넣어서 아이템 선택시 폼에는 텍스트가 뜨고, SelectedValue 멤버변수에는 선택된 아이템의 값이 들어가도록 할 수 있다. 그런데 정작 이걸 입력하는 방법이 DataSet같은 걸 DataSouece에 바인딩하는 법밖에 없어서, 일반적으로는 DB에서 가져온 테이블을 바인딩하거나 할 때만 사용이 가능하다.

 

이 기능을 코드에서 직접 처리할 수 있는 클래스를 제작해 보았다.

 
```csharp 
public class ComboBoxItemSet
{
    // 텍스트-값 쌍을 나타내는 내부 클래스.
    class TextValuePair
    {
        string m_text;
        object m_value;
        public string Text { get { return m_text; } }
        public object Value { get { return m_value; } }

        public TextValuePair(string text, object value)
        {
            m_text = text;
            m_value = value;
        }

        public override string ToString()
        {
            return m_value.ToString();
        }
    }

    ArrayList list = new ArrayList();

    public void Add(string text, object value)
    {
        list.Add( new TextValuePair(text, value) );
    }

    public void Bind(System.Windows.Forms.ComboBox comboBox)
    {
        if (list.Count < 1) return; // 값이 없으면 바인딩할 필요가 없다.

        comboBox.DataSource = list;
        comboBox.DisplayMember = "Text";
        comboBox.ValueMember = "Value";         
    }
}
```
 
사용은 Add 함수로 텍스트-값 쌍을 입력한 후, Bind 함수로 연결할 콤보박스 컨트롤을 지정해주면 된다.
