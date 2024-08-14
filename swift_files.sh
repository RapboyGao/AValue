#!/bin/bash

# 输出文件
output_file="summary.md"

# 清空输出文件
echo "" >$output_file

# 创建一个临时目录
temp_dir=$(mktemp -d)

# 使用 rsync 排除 .gitignore 中的内容
rsync -av --exclude-from='.gitignore' . "$temp_dir"

# 查找所有 .swift 文件（排除 Package.swift、.build 目录和 Tests 目录中的文件）并总结其路径和内容
find "$temp_dir" -type f -name "*.swift" ! -path "$temp_dir/.build/*" ! -path "$temp_dir/Tests/*" | while read -r file; do
    # 获取相对路径
    relative_path="${file#$temp_dir/}"
    # 写入文件路径到输出文件
    echo "### File: $relative_path" >>$output_file
    # 开始代码块
    echo '```swift' >>$output_file
    # 读取文件内容并写入输出文件
    cat "$file" >>$output_file
    # 结束代码块
    echo '```' >>$output_file
    # 添加一个空行分隔每个文件
    echo "" >>$output_file
done

# 删除临时目录
rm -rf "$temp_dir"

# 打印完成信息
echo "Summary has been written to $output_file"
