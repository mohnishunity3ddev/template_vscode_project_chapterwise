. $PSScriptRoot\_variables.ps1

# Required arguments
$projNameArg = $args[0]
$chapterNumberArg = $args[1]

if($null -eq $projNameArg) {
    Write-Warning "no project name given. Creating template 'tempproj'"
    $projNameArg = "tempproj"
}

$foundChapterDir = $null
$foundChapterFolderName = $null

$Chapters = Get-ChildItem -Path $SRC_DIR_PATH\
foreach($Chapter in $Chapters) 
{    
    $ChapterName = Split-Path -Path $Chapter -Leaf
    if($ChapterName -match $chapterNumberArg) {
        $foundChapterDir = $Chapter
        $foundChapterFolderName = $ChapterName
    }
}

if($null -ne $foundChapterDir) {
    Write-Output "Found Chapter: $foundChapterDir"

    Set-Location $foundChapterDir
    
    mkdir .\$projNameArg
    Set-Location .\$projNameArg
    
    mkdir bin
    mkdir src
    touch .\src\$projNameArg.cpp
    touch CMakeLists.txt

    $chapterNumber = ""
    if($null -eq $chapterNumberArg) {
        $chapterNumber = "##"
    } else {
        $chapterNumber = $chapterNumberArg
    }
    # Add content
    Add-Content -Path .\CMakeLists.txt -Value "cmake_minimum_required(VERSION 3.22.0)`n`nproject($projNameArg)`n`ninclude(../../../cmake_macros/prac.cmake)`n`nSETUP_APP($projNameArg `"Chapter$chapterNumber`")`n`ntarget_link_libraries($projNameArg opengl32 glad glfw SharedUtils)"
    Add-Content -Path .\src\$projNameArg.cpp -Value "#include <iostream>`n`nint main() {`n    std::cout << `"Hello, World! from $projNameArg\n`";`n    return 0;`n}"
    Add-Content -Path $PROJECT_ROOT_DIR_PATH\CMakeLists.txt -Value "`nadd_subdirectory(src/$foundChapterFolderName/$projNameArg)"
} else {
    Write-Error "Could not find Chapter associated with given arg: $chapterNumberArg"
}

# Set-Location $PROJECT_ROOT_DIR_PATH



# if($null -ne $chapterNumberArg) {
#     Set-Location ..
#     $projectPath = "$PROJECT_ROOT_DIR_PATH\src\Chapter$chapterNumber"
#     if((Test-Path -Path $projectPath) -eq $false) {
#         mkdir $projectPath
#     }
#     Move-Item .\$projNameArg $projectPath
# }