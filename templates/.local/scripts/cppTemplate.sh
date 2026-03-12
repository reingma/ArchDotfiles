#!/usr/bin/env bash
PROJECT_NAME=$1
VERSION="3.20"

mkdir -p "$PROJECT_NAME"/{src,include,build,tests}

#Creating CMakeLists.txt
cat <<EOF >"$PROJECT_NAME/CMakeLists.txt"
cmake_minimum_required(VERSION $VERSION)
project($PROJECT_NAME VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(\${PROJECT_NAME} src/main.cpp)
target_include_directories(\${PROJECT_NAME} PUBLIC include)
EOF

#Create main
echo '#include <iostream>

int main() {
    std::cout << "Hello world!" << std::endl;
    return 0;
}' >"$PROJECT_NAME/src/main.cpp"

#Create envrc
echo "use flake" >"$PROJECT_NAME/.envrc"

cd "$PROJECT_NAME" && direnv allow
