#==================
# ENUMS
#==================

#https://devblogs.microsoft.com/scripting/working-with-enums-in-powershell-5/
#https://communary.net/2014/11/20/quick-tip-enum-with-string-values/
#https://social.technet.microsoft.com/wiki/contents/articles/26436.how-to-create-and-use-enums-in-powershell.aspx
#https://mcpmag.com/articles/2018/05/03/using-a-custom-enum.aspx

#DEFAULT COLOURS
Enum Colors {
    default
    dark
    light
    accent
    good
    warning
    attention
}

Enum FontType {
    default
    monospace
}

Enum FontSize {
    default
    small
    medium
    large
    extraLarge
}

Enum HorizontalAlignment {
    left
    center
    right
}

Enum VerticalAlignment {
    top
    center
    bottom
}

Enum FontWeight {
    default
    lighter
    bolder
}

Enum TextBlockStyle {
    default
    heading
}

Enum BlockElementHeight {
    auto
    stretch
}

Enum Spacing {
    default
    none
    small
    medium
    large
    extraLarge
    padding
}

#Cannot have dot spaced enum values,
#PROCESS THESE AS "Action.[EnumValue]"
Enum ISelectAction {
    Execute
    OpenUrl
    Submit
    ToggleVisibility
}

Enum ImageSize {
    auto
    stretch
    small
    medium
    large
}

Enum ActionStyle {
    default
    positive
    destructive
}

Enum ActionMode {
    primary
    secondary
}

Enum ContainerStyle {
    default
    emphasis
    good
    attention
    warning
    accent
}