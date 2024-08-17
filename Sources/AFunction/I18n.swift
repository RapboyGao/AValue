import Foundation

/// 所有的字符串都由这里产生
enum I18n {
    // 静态常量，用于表示不同的本地化字符串
    /// 包含型数值约束
    static let numberConstraintInclusive = NSLocalizedString("number_constraint_inclusive", comment: "Inclusive number constraint")

    /// 最小值排除，最大值包含的数值约束
    static let numberConstraintExclusiveMinInclusiveMax = NSLocalizedString("number_constraint_exclusive_min_inclusive_max", comment: "Exclusive minimum and inclusive maximum number constraint")

    /// 最小值包含，最大值排除的数值约束
    static let numberConstraintInclusiveMinExclusiveMax = NSLocalizedString("number_constraint_inclusive_min_exclusive_max", comment: "Inclusive minimum and exclusive maximum number constraint")

    /// 排除型数值约束
    static let numberConstraintExclusive = NSLocalizedString("number_constraint_exclusive", comment: "Exclusive number constraint")

    /// 包含型数值约束，带步长
    static let numberConstraintInclusiveWithStep = NSLocalizedString("number_constraint_inclusive_with_step", comment: "Inclusive number constraint with step")

    /// 最小值排除，最大值包含的数值约束，带步长
    static let numberConstraintExclusiveMinInclusiveMaxWithStep = NSLocalizedString("number_constraint_exclusive_min_inclusive_max_with_step", comment: "Exclusive minimum and inclusive maximum number constraint with step")

    /// 最小值包含，最大值排除的数值约束，带步长
    static let numberConstraintInclusiveMinExclusiveMaxWithStep = NSLocalizedString("number_constraint_inclusive_min_exclusive_max_with_step", comment: "Inclusive minimum and exclusive maximum number constraint with step")

    /// 排除型数值约束，带步长
    static let numberConstraintExclusiveWithStep = NSLocalizedString("number_constraint_exclusive_with_step", comment: "Exclusive number constraint with step")

    /// 数值约束区间，排除一个值
    static let numberConstraintRangeExcluding = NSLocalizedString("number_constraint_range_excluding", comment: "Number constraint range excluding a value")

    /// 数值约束区间，排除一个值且带步长
    static let numberConstraintRangeExcludingWithStep = NSLocalizedString("number_constraint_range_excluding_with_step", comment: "Number constraint range excluding a value with step")

    /// 整数区间
    static let integerConstraintInclusive = NSLocalizedString("integer_constraint_inclusive", comment: "Inclusive integer constraint")

    /// 正整数
    static let integerConstraintPositive = NSLocalizedString("integer_constraint_positive", comment: "Positive integer constraint")

    /// 非负整数
    static let integerConstraintNonNegative = NSLocalizedString("integer_constraint_non_negative", comment: "Non-negative integer constraint")

    /// 负整数
    static let integerConstraintNegative = NSLocalizedString("integer_constraint_negative", comment: "Negative integer constraint")

    /// 非正整数
    static let integerConstraintNonPositive = NSLocalizedString("integer_constraint_non_positive", comment: "Non-positive integer constraint")

    /// 非零整数
    static let integerConstraintNonZero = NSLocalizedString("integer_constraint_non_zero", comment: "Non-zero integer constraint")

    /// 排除特定值的整数区间
    static let integerConstraintRangeExcluding = NSLocalizedString("integer_constraint_range_excluding", comment: "Integer range excluding a value")

    /// 单一整数值
    static let integerConstraintSingleValue = NSLocalizedString("integer_constraint_single_value", comment: "Single integer value")

    /// 自然数
    static let integerConstraintNaturalNumber = NSLocalizedString("integer_constraint_natural_number", comment: "Natural number constraint")

    /// 偶数
    static let integerConstraintEvenNumber = NSLocalizedString("integer_constraint_even_number", comment: "Even number constraint")

    /// 奇数
    static let integerConstraintOddNumber = NSLocalizedString("integer_constraint_odd_number", comment: "Odd number constraint")

    /// 整数集合
    static let integerConstraintIntegerSet = NSLocalizedString("integer_constraint_integer_set", comment: "Integer set constraint")

    /// 正实数
    static let realNumberConstraintPositive = NSLocalizedString("real_number_constraint_positive", comment: "Positive real number constraint")

    /// 非负实数
    static let realNumberConstraintNonNegative = NSLocalizedString("real_number_constraint_non_negative", comment: "Non-negative real number constraint")

    /// 负实数
    static let realNumberConstraintNegative = NSLocalizedString("real_number_constraint_negative", comment: "Negative real number constraint")

    /// 非正实数
    static let realNumberConstraintNonPositive = NSLocalizedString("real_number_constraint_non_positive", comment: "Non-positive real number constraint")

    /// 非零实数
    static let realNumberConstraintNonZero = NSLocalizedString("real_number_constraint_non_zero", comment: "Non-zero real number constraint")

    /// 单一实数值
    static let realNumberConstraintSingleValue = NSLocalizedString("real_number_constraint_single_value", comment: "Single real number value")

    /// 实数
    static let realNumberConstraintRealNumber = NSLocalizedString("real_number_constraint_real_number", comment: "Real number constraint")

    /// 有理数
    static let realNumberConstraintRationalNumber = NSLocalizedString("real_number_constraint_rational_number", comment: "Rational number constraint")

    /// 无限范围
    static let realNumberConstraintInfiniteRange = NSLocalizedString("real_number_constraint_infinite_range", comment: "Infinite range constraint")

    /// 步长约束
    static let stepConstraintPositive = NSLocalizedString("step_constraint_positive", comment: "Positive step constraint")
    static let stepConstraintNonNegative = NSLocalizedString("step_constraint_non_negative", comment: "Non-negative step constraint")
    static let stepConstraintNegative = NSLocalizedString("step_constraint_negative", comment: "Negative step constraint")
    static let stepConstraintNonPositive = NSLocalizedString("step_constraint_non_positive", comment: "Non-positive step constraint")
    static let stepConstraintNonZero = NSLocalizedString("step_constraint_non_zero", comment: "Non-zero step constraint")

    // 静态方法，用于返回带占位符的本地化字符串
    static func inclusiveRange(min: Double, max: Double) -> String {
        return String(format: NSLocalizedString("inclusive_range_format", comment: "Inclusive range with min and max"), min, max)
    }

    static func exclusiveMinInclusiveMaxRange(min: Double, max: Double) -> String {
        return String(format: NSLocalizedString("exclusive_min_inclusive_max_range_format", comment: "Exclusive minimum and inclusive maximum range with min and max"), min, max)
    }

    static func inclusiveMinExclusiveMaxRange(min: Double, max: Double) -> String {
        return String(format: NSLocalizedString("inclusive_min_exclusive_max_range_format", comment: "Inclusive minimum and exclusive maximum range with min and max"), min, max)
    }

    static func exclusiveRange(min: Double, max: Double) -> String {
        return String(format: NSLocalizedString("exclusive_range_format", comment: "Exclusive range with min and max"), min, max)
    }

    static func inclusiveRangeWithStep(min: Double, max: Double, step: Double) -> String {
        return String(format: NSLocalizedString("inclusive_range_with_step_format", comment: "Inclusive range with min, max, and step"), min, max, step)
    }

    static func exclusiveMinInclusiveMaxRangeWithStep(min: Double, max: Double, step: Double) -> String {
        return String(format: NSLocalizedString("exclusive_min_inclusive_max_range_with_step_format", comment: "Exclusive minimum and inclusive maximum range with step: min = %.2f, max = %.2f, step = %.2f"), min, max, step)
    }

    static func inclusiveMinExclusiveMaxRangeWithStep(min: Double, max: Double, step: Double) -> String {
        return String(format: NSLocalizedString("inclusive_min_exclusive_max_range_with_step_format", comment: "Inclusive minimum and exclusive maximum range with step: min = %.2f, max = %.2f, step = %.2f"), min, max, step)
    }

    static func exclusiveRangeWithStep(min: Double, max: Double, step: Double) -> String {
        return String(format: NSLocalizedString("exclusive_range_with_step_format", comment: "Exclusive range with step: min = %.2f, max = %.2f, step = %.2f"), min, max, step)
    }

    static func rangeExcluding(min: Double, max: Double, exclude: Double) -> String {
        return String(format: NSLocalizedString("range_excluding_format", comment: "Range excluding a value with min, max, and exclude"), min, max, exclude)
    }

    static func rangeExcludingWithStep(min: Double, max: Double, exclude: Double, step: Double) -> String {
        return String(format: NSLocalizedString("range_excluding_with_step_format", comment: "Range excluding a value with step: min = %.2f, max = %.2f, exclude = %.2f, step = %.2f"), min, max, exclude, step)
    }

    // Functions descriptions
    static let cosFunctionDescription = NSLocalizedString("cos_function_description", comment: "Description of cosine function")
    static let sinFunctionDescription = NSLocalizedString("sin_function_description", comment: "Description of sine function")
    static let maxFunctionDescription = NSLocalizedString("max_function_description", comment: "Description of max function")
    static let distanceFunctionDescription = NSLocalizedString("distance_function_description", comment: "Description of distance function")
    static func functionDescription(name: String) -> String {
        return String(format: NSLocalizedString("function_description_format", comment: "Function description format"), name)
    }

    // Argument names and details
    static let angleArgumentName = NSLocalizedString("angle_argument_name", comment: "Name for angle argument")
    static let angleArgumentDetail = NSLocalizedString("angle_argument_detail", comment: "Detail for angle argument")

    static let value1ArgumentName = NSLocalizedString("value1_argument_name", comment: "Name for first value argument")
    static let value1ArgumentDetail = NSLocalizedString("value1_argument_detail", comment: "Detail for first value argument")

    static let value2ArgumentName = NSLocalizedString("value2_argument_name", comment: "Name for second value argument")
    static let value2ArgumentDetail = NSLocalizedString("value2_argument_detail", comment: "Detail for second value argument")

    static let location1ArgumentName = NSLocalizedString("location1_argument_name", comment: "Name for first location argument")
    static let location1ArgumentDetail = NSLocalizedString("location1_argument_detail", comment: "Detail for first location argument")

    static let location2ArgumentName = NSLocalizedString("location2_argument_name", comment: "Name for second location argument")
    static let location2ArgumentDetail = NSLocalizedString("location2_argument_detail", comment: "Detail for second location argument")
}
