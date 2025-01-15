# AValue

AValue 是一个用于处理多种类型值的 Swift 库，支持数值、点、地理位置、布尔值、字符串、地面风限制、持续时间、日历时间和日期差异等类型。

## 安装

### Swift Package Manager

在您的 `Package.swift` 文件中添加以下依赖项：

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AValue.git", from: "1.0.0")
]
```

然后在目标中添加 `AValue` 作为依赖项：

```swift
.target(
    name: "YourTargetName",
    dependencies: ["AValue"]
)
```

## 使用示例

### 创建和操作 AValue

```swift
import AValue

// 创建数值类型的 AValue
let numberValue: AValue = 42.0

// 创建点类型的 AValue
let pointValue: AValue = .point(x: 3.0, y: 4.0)

// 创建地理位置类型的 AValue
let locationValue: AValue = .location(latitude: 37.7749, longitude: -122.4194)

// 创建布尔值类型的 AValue
let booleanValue: AValue = true

// 创建字符串类型的 AValue
let stringValue: AValue = "Hello, World!"

// 创建地面风限制类型的 AValue
let windLimit = AWindLimit(headWind: 50, tailWind: 10, crossWind: 30)
let groundWindValue: AValue = .groundWind(limit: windLimit)

// 操作 AValue
let sum = try numberValue.add(10.0)
let difference = try pointValue.subtract(.point(x: 1.0, y: 1.0))
```
