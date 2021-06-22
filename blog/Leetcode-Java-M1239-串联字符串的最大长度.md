# Leetcode-Java-M1239-串联字符串的最大长度



本题个人用了三个小时，最终没有解出来，分享下解题过程和思路

## 题目

[M1239]([1239. 串联字符串的最大长度 - 力扣（LeetCode） (leetcode-cn.com)](https://leetcode-cn.com/problems/maximum-length-of-a-concatenated-string-with-unique-characters/))

## 个人解题过程



TDD-测试驱动开发，使用Junit5通过单元测试覆盖不同场景，从而一步一步修改代码。



### 单元测试

```java
class M1239Test {

    static Stream<Arguments> testCaseParams() {
        return Stream.of(
                Arguments.of(Collections.singletonList("abcd"), 4),
                Arguments.of(Arrays.asList("b", "c"), 2),
                Arguments.of(Arrays.asList("a", "b", "c"), 3),
                Arguments.of(Arrays.asList("b", "c", "abc"), 3),
                Arguments.of(Arrays.asList("a", "b", "ab"), 2),
                Arguments.of(Arrays.asList("b", "c", "aabc"), 2),
                Arguments.of(Arrays.asList("a", "abc", "d", "de", "def"), 6), // xxxxx
                Arguments.of(Arrays.asList("a", "b", "c", "cd", "de", "def"), 6) // xxx
        );
    }

    @MethodSource("testCaseParams")
    @ParameterizedTest
    void maxLengthTest(List<String> arr, int expectedLength) {
        M1239 m1239 = new M1239();
        int length = m1239.maxLength(arr);
        Assertions.assertEquals(expectedLength, length);
    }
}
```



### 实现题目逻辑



```java
package com.learning.midium;

import java.util.List;

/**
 * 串联字符串的最大长度:
 * 给定一个字符串数组 arr，字符串 s 是将 arr 某一子序列字符串连接所得的字符串，如果 s 中的每一个字符都只出现过一次，那么它就是一个可行解。
 * <p>
 * 请返回所有可行解 s 中最长长度。
 *
 * @author wcy
 */
public class M1239 {

    public int maxLength(List<String> arr) {
        int arrSize = arr.size();
        if (arrSize == 1) {
            return arr.get(0).length();
        }
        // 有效最大长度，默认0
        int validLength = 0;
        /**
         * 有效的串联：
         * 1. 无重复字符
         *
         * 无效的串联：
         * 1. 相加长度超过26
         * 2. 重复的字符: 遍历对比
         */
        for (int i = 0; i < arrSize; i++) {
            if (repetitionSelfInspection(arr.get(i))) {
                continue;
            }
            StringBuilder appendStr = new StringBuilder(arr.get(i));
            for (int j = i + 1; j < arrSize; j++) {
                String jStr = arr.get(j);
                if (repetitionSelfInspection(jStr)) {
                    continue;
                }
                // 判断是否有重复字符，如果重复，则跳过内层for(int j...)循环
                boolean charRepetition = false;
                char[] iStrChars = appendStr.toString().toCharArray();
                char[] jStrChars = jStr.toCharArray();
                for (char iStrChar : iStrChars) {
                    for (char jStrChar : jStrChars) {
                        // 字符重复，则allBreak = true
                        if (charRepetition = (iStrChar == jStrChar)) {
                            break;
                        }
                    }
                    if (charRepetition) {
                        break;
                    }
                }
                if (charRepetition) {
                    continue;
                }

                // 字符无重复，则进行append操作，判断长度是否超过26
                if ((appendStr.length() + jStr.length()) > 26) {
                    continue;
                }
                appendStr.append(jStr);
            }
            // 确认长度，保存最长的一次结果
            int appendStrLength = appendStr.length();
            validLength = Math.max(appendStrLength, validLength);
        }

        return validLength;
    }

    /**
     * 判断是否有重复字符
     *
     * @return true - 包含，false - 不包含
     */
    private boolean repetitionSelfInspection(String str) {
        char[] chars = str.toCharArray();
        for (char aChar : chars) {
            if (str.indexOf(aChar) != str.lastIndexOf(aChar)) {
                return true;
            }
        }
        return false;
    }
}
```



### 个人总结

通过题目说明，直观的去解题，从最简单的场景开始实现，最终在`["a", "abc", "d", "de", "def"]`的场景出现后，现有代码已经没办法解决问题，此思路不通。

现代码的主要问题在于，通过两层循环，在abc + d后，后面的循环在遇到def的时候，正确的是将d换为def，但这里会判定def为重复字符串而跳过，所以这个通过这种方式没办法处理。



## 官方解题详解



### 回溯 + 位运算



由于构成可行解的字符串仅包含小写字母，且无重复元素，26个英文小写字母，不考虑先后顺序，可以这样展示：

- 'ab cdef ghij klmn opqr stuv wxyz' --> '11 1111 1111 1111 1111 1111 1111'
- ‘a’ --> ‘10 0000 0000 0000 0000 0000 0000’
- ‘abc’ --> ‘11 1000 0000 0000 0000 0000 0000’
- ‘acgk’ --> ‘10 1000 1000 1000 0000 0000 0000’