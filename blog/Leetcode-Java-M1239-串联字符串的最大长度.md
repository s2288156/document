# Leetcode-Java-M1239-串联字符串的最大长度



本题个人用了三个小时，最终没有解出来，分享下解题过程和思路，顺便学习一下**回溯算法**

## 1. 题目

[M1239]([1239. 串联字符串的最大长度 - 力扣（LeetCode） (leetcode-cn.com)](https://leetcode-cn.com/problems/maximum-length-of-a-concatenated-string-with-unique-characters/))

## 2. 个人解题过程



TDD-测试驱动开发，使用Junit5通过单元测试覆盖不同场景，从而一步一步修改代码。



### 2.1 单元测试

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



### 2.2 实现题目逻辑



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



### 2.3 [个人解法问题]()

通过题目说明，直观的去解题，从最简单的场景开始实现，最终在`["a", "abc", "d", "de", "def"]`的场景出现后，现有代码已经没办法解决问题，此思路不通。

现代码的主要问题在于，通过两层循环，在abc + d后，后面的循环在遇到def的时候，正确的是将d换为def，但这里会判定def为重复字符串而跳过，所以这个通过这种方式没办法处理。



## 3. 官方解法（回溯 + 位运算）



### 3.1 官方java解法

> 作者：LeetCode-Solution
> 链接：https://leetcode-cn.com/problems/maximum-length-of-a-concatenated-string-with-unique-characters/solution/chuan-lian-zi-fu-chuan-de-zui-da-chang-d-g6gk/
> 来源：力扣（LeetCode）

```java
class Solution {
    int ans = 0;

    public int maxLength(List<String> arr) {
        List<Integer> masks = new ArrayList<Integer>();
        for (String s : arr) {
            int mask = 0;
            for (int i = 0; i < s.length(); ++i) {
                int ch = s.charAt(i) - 'a';
                if (((mask >> ch) & 1) != 0) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0;
                    break;
                }
                mask |= 1 << ch; // 将 ch 加入 mask 中
            }
            if (mask > 0) {
                masks.add(mask);
            }
        }

        backtrack(masks, 0, 0);
        return ans;
    }

    public void backtrack(List<Integer> masks, int pos, int mask) {
        if (pos == masks.size()) {
            ans = Math.max(ans, Integer.bitCount(mask));
            return;
        }
        if ((mask & masks.get(pos)) == 0) { // mask 和 masks[pos] 无公共元素
            backtrack(masks, pos + 1, mask | masks.get(pos));
        }
        backtrack(masks, pos + 1, mask);
    }
}
```

### 3.2 第一步，构建筛选无重复字母的字符串

遍历字符串数组，筛选出无重复字母的字符串，将其**二进制数**放入数组**masks**



由于构成可行解的字符串仅包含小写字母，且无重复元素，26个英文小写字母，不考虑先后顺序，可以这样展示：

- 'zdcba' --> '10 0000 0000 0000 0000 0000 1111'
- ‘a’ --> ‘00 0000 0000 0000 0000 0000 0001’
- ‘abc’ --> ‘00 0000 0000 0000 0000 0000 0111’
- ‘cab’ --> ‘00 0000 0000 0000 0000 0000 0111’



代码实现方式:

```java

// if s.charAt(i) == 'a', 则 ch = 0,代表位于二进制第1位
// if s.charAt(i) == 'c', 则 ch = 2,代表位于二进制第3位
// 依次类推 ... 通过这种方式，将无重复字母字符串转为二进制数，以Integer保存到masks数组
int ch = s.charAt(i) - 'a';

// 举例："abc"  
// fori  i=0; ch = 'c'-'a' = 2, mask=0;  (mask >> ch) = 0000 & 0001 = 0000; 0!=0 break;  mask |= 1 << ch = 0100
// i=1; ch = 'b'-'a' = 1, mask=0100; (mask >> ch) = 0010 & 0001 = 0000; 0!=0 break; mask |= (1 << ch) -> 0100 |= 0010 = 0110
// i=2; ch = 'a'-'a' = 0, mask=0110; (mask >> ch) = 0110 & 0001 = 0000; 0!=0 break; mask |= (1 << ch) -> 0110 |= 0001 = 0111
// 得出"abc"对应的二进制值 0111
if (((mask >> ch) & 1) != 0) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
    mask = 0;
    break;
}
```



### 3.3 第二步，回溯法

通过第一步，将字符串数组转换为无重复字母的二进制数组，以`["a", "b", "c", "cd", "de", "def"]`为例，转换后的数组（这里二进制表示）为：

- a: 0001 
- b: 0010
- c: 0100
- cd: 1100
- de: 0001 1000
- def: 0011 1000



```java
public void backtrack(List<Integer> masks, int pos, int mask) {
    if (pos == masks.size()) {
        ans = Math.max(ans, Integer.bitCount(mask));
        return;
    }
    if ((mask & masks.get(pos)) == 0) { // mask 和 masks[pos] 无公共元素
        backtrack(masks, pos + 1, mask | masks.get(pos));
    }
    backtrack(masks, pos + 1, mask); // 有公共元素
}
// ans=0,  masks=[0001, 0010, 0100, 1100, 0001 1000, 0011 1000] => (["a", "b", "c", "cd", "de", "def"])
// 1. pos=0,mask=0, mask & masks.get(pos)  -->  0000 & 0001 = 0000  == 0  mask和masks[pos]无公共元素
// 则 backtrack(masks, pos + 1, mask | masks.get(pos)); 0000 | 0001 = 0001; => backtrack(masks, 1, 0001)，下一层递归
// 2. pos=1 不等于 mask.size=6,mask=0001;  mask & masks.get(pos) >   0001 & 0010 = 0000 == 0,无公共元素 backtrack(masks, 2, 0011)
// 3. pos=2 mask=0011,     0011 & 0100 = 0000,无公共元素 backtrack(masks, 3, 0111)
// 4. pos=3 mask=0111,  0111 & 1100 = 0100 != 0,有公共元素 backtrack(masks, 4, mask) => backtrack(masks, 4, 0111) 
// 5. pos=4 mask=0111,  0111 & 0001 1000 = 0,无公共元素 backtrack(masks, 5, 0001 1111) 
// 6. pos=5 mask=0001 1111,   0001 1111 & 0011 1000 = 0001 1000; 有公共元素 backtrack(masks, 6, 0001 1111) 
// 7. pos=6 mask=0001 1111,  pos == masks.size(); ans = max(0, Integer.bitCount(mask)) = 0001 1111 返回递归  <<<<< ant=0001 1111
// ->6. pos=5 mask=0001 1111  有公共元素 返回递归
// ->5. pos=4 mask=0111 此处从无公共元素逻辑递归中返回出来，执行 backtrack(masks, pos + 1, mask)
// ->6. pos=5 mask=0111 无公共元素 backtrack(masks, 5, 0011 1111) 
// ->7. pos=6 mask=0011 1111,  pos == masks.size(); ans = max(0, Integer.bitCount(mask)) = 0011 1111 返回递归  <<<<< ant=0011 1111
// 已经得到最大值，后续递归逻辑处理流程相似，最终结果为ant = 0011 1111 = abcdef

```



## 4. 回溯算法

什么是回溯算法，通俗的讲，类似于电影《蝴蝶效应》，在事情的关键转折点，做出不同的选择，以获得期望的结果。



这道题就符合这样的场景，它的关键点就在于字段串联过程中，再某个点虽然没有重复字段，但不是最长最优组合，比如`["a", "b", "c", "cd", "de", "def"]`，当`abc`和`de`串联后，在遇到`def`，就会判定为重复字段。所以需要回溯到`de`这个点不进行串联，与`def`串联，得到期望值。

