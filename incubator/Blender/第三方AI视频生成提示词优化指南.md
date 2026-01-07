# 第三方AI视频生成提示词优化指南

## 🎯 目标
为豆包、Pika、Kling、Runway等AI视频生成工具优化提示词，生成高质量游戏角色动画

---

## 📋 项目需求

### 角色信息
- **外观**：蓝发男孩、白色毛衣、拿着棕色书本
- **风格**：3D卡通风格
- **视角**：正面/斜侧面（与参考图一致）
- **背景**：绿色背景（方便后期抠图）

### 动画需求
8个表演性动画（原地动作，无移动）：
1. Idle (待机) - 轻微呼吸动作
2. Wave (挥手) - 友好手势
3. Happy (开心) - 微笑、轻微跳跃
4. Sad (悲伤) - 低头、沮丧
5. Surprised (惊讶) - 眼睛睁大、后退
6. Reading (阅读) - 看书、翻页
7. Crying (大哭) - 流泪、抽泣
8. Angry (愤怒) - 双肩耸起、愤怒表情

### 技术要求
- **时长**：1-2秒（适合游戏循环）
- **帧率**：24fps或更高
- **分辨率**：512x512 或 1024x1024
- **循环**：首尾帧相似，可无缝循环
- **一致性**：所有动画保持角色外观一致

---

## 🎨 提示词优化原则

### 1. 角色一致性原则
**核心**：每个提示词都要包含完整的角色描述

**模板**：
```
[角色外观] + [动作描述] + [视角] + [背景] + [风格] + [技术要求]
```

**示例**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
[动作描述],
front view, standing in place,
green screen background,
smooth animation, looping motion
```

### 2. 动作描述原则
**要点**：
- ✅ 描述具体动作（不要模糊）
- ✅ 强调"原地"、"standing in place"
- ✅ 强调"循环"、"looping"、"seamless"
- ✅ 避免相机运动描述
- ❌ 不要提"风格"、"2D"、"游戏"等词（容易改变角色）

### 3. 背景控制原则
**要点**：
- ✅ 明确指定"green screen background"
- ✅ 添加"chroma key green"
- ✅ 强调"solid color background"
- ❌ 避免复杂背景描述

### 4. 视角控制原则
**要点**：
- ✅ 使用"same view as reference"
- ✅ 或明确指定"front view"、"side view"
- ✅ 强调"no camera movement"
- ❌ 避免"cinematic"、"dynamic angle"等词

---

## 📝 8个动画的优化提示词

### 1. Idle (待机)

**豆包/Pika/Kling通用版**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
gentle breathing motion, slight up and down movement of chest and shoulders,
standing in place, front view, no movement of feet,
green screen background, solid green color,
smooth looping animation, seamless loop, natural idle pose
```

**Runway Gen-4专用版**（更详细）：
```
Character: 3D stylized boy, blue hair, white sweater, brown book in hands
Action: Idle breathing animation - subtle chest rise and fall, minimal shoulder movement, relaxed standing pose
Camera: Static front view, no camera motion
Background: Chroma key green (#00FF00), solid color
Technical: Looping animation, 2 seconds, smooth motion, seamless start/end
```

**负面提示（如果工具支持）**：
```
no walking, no jumping, no camera movement, no background details,
no style change, no character transformation
```

---

### 2. Wave (挥手)

**通用版**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
waving hand animation, one hand waves in friendly gesture while other hand holds book,
wave motion from low to high then back to rest position,
standing in place, front view, feet stay still,
green screen background, solid green color,
smooth looping animation, seamless loop
```

**详细版**：
```
Character: Same 3D boy, blue hair, white sweater, brown book
Action: Right hand waves hello - starts at side, raises up, waves 2-3 times, returns to side. Left hand holds book steady. Friendly smile.
Timing: 2 seconds total, wave takes 1.5 seconds, 0.5 second return
Camera: Static front view
Background: Green screen
Loop: Seamless start and end positions
```

---

### 3. Happy (开心)

**通用版**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
happy expression animation, big smile, eyes light up,
slight bouncing motion, shoulders lift slightly,
standing in place, front view, minimal movement,
green screen background, solid green color,
smooth looping animation, joyful energy
```

**详细版**：
```
Character: 3D boy, blue hair, white sweater, brown book
Action: Happy emotion - smile grows, eyes brighten, slight bounce (2-3 small hops in place), shoulders lift with joy
Expression: Genuine happiness, warm smile
Movement: Vertical bounce only, feet stay in same spot
Camera: Static front view
Background: Green screen
Loop: Returns to neutral happy pose
```

---

### 4. Sad (悲伤)

**通用版**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
sad expression animation, looking down, shoulders droop,
slow gentle swaying motion, melancholy mood,
standing in place, front view, minimal movement,
green screen background, solid green color,
smooth looping animation, subtle sadness
```

**详细版**：
```
Character: 3D boy, blue hair, white sweater, brown book
Action: Sad emotion - head tilts down, shoulders slump, slow sigh motion, book held loosely
Expression: Downcast eyes, slight frown, dejected posture
Movement: Slow breathing, gentle sway, no walking
Camera: Static front view
Background: Green screen
Loop: Continuous sad idle state
```

---

### 5. Surprised (惊讶)

**通用版**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
surprised reaction animation, eyes widen suddenly, eyebrows raise,
slight backward lean, mouth opens in surprise,
standing in place, front view, quick reaction then hold,
green screen background, solid green color,
smooth animation with sudden surprise moment
```

**详细版**：
```
Character: 3D boy, blue hair, white sweater, brown book
Action: Surprise reaction - eyes suddenly widen, eyebrows shoot up, mouth opens, slight backward lean (upper body only), book held firmly
Timing: Quick surprise (0.3s), hold surprised pose (1.2s), slight relax (0.5s)
Movement: Upper body leans back slightly, feet planted
Camera: Static front view
Background: Green screen
Loop: Returns to alert surprised state
```

---

### 6. Reading (阅读)

**通用版**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
reading animation, looking down at book, eyes move as if reading,
occasional page turn gesture, focused expression,
standing in place, front view, book held at chest level,
green screen background, solid green color,
smooth looping animation, studious mood
```

**详细版**：
```
Character: 3D boy, blue hair, white sweater, brown book
Action: Reading - eyes look down at book, subtle eye movement (reading), one hand turns page midway through loop, returns to reading
Expression: Focused, concentrated, slight smile
Movement: Minimal - only eyes, slight head tilt, page turn
Camera: Static front view
Background: Green screen
Loop: Continuous reading cycle with one page turn
```

---

### 7. Crying (大哭)

**通用版**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
crying animation, tears on face, sobbing motion,
shoulders shake with crying, head tilts down,
standing in place, front view, emotional distress,
green screen background, solid green color,
smooth looping animation, visible sadness
```

**详细版**：
```
Character: 3D boy, blue hair, white sweater, brown book
Action: Crying - tears stream down face, shoulders shake with sobs, head bowed, one hand wipes eyes while other holds book
Expression: Crying face, closed or squinted eyes, mouth in crying shape
Movement: Shaking shoulders, head bobbing with sobs, no walking
Camera: Static front view
Background: Green screen
Loop: Continuous crying state
```

---

### 8. Angry (愤怒)

**通用版**：
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
angry expression animation, furrowed brows, frowning,
shoulders raised in anger, tense posture,
standing in place, front view, firm stance,
green screen background, solid green color,
smooth looping animation, controlled anger
```

**详细版**：
```
Character: 3D boy, blue hair, white sweater, brown book
Action: Angry emotion - eyebrows furrow, eyes narrow, frown deepens, shoulders rise and tense, book gripped tightly
Expression: Angry face, stern look, tense jaw
Movement: Shoulders rise, slight forward lean (upper body), feet planted firmly
Camera: Static front view
Background: Green screen
Loop: Maintains angry stance
```

---

## 🛠️ 不同工具的提示词调整

### 豆包（字节跳动）
**特点**：
- 理解中文更好
- 对"风格"敏感（容易改变角色）
- 背景控制较弱

**优化策略**：
- ✅ 使用中文提示词
- ✅ 避免提"风格"、"2D"、"游戏"
- ✅ 强调"保持原图人物完全一致"
- ✅ 多次强调"绿色背景"

**示例**：
```
蓝发男孩，白色毛衣，手拿棕色书本，
待机呼吸动画，轻微上下起伏，
原地站立，视角与原图完全一致，
绿色背景，纯色绿幕，
流畅循环动画，保持人物完全一致
```

---

### Pika 1.5
**特点**：
- 速度快，效果稳定
- 角色一致性好
- 支持详细的动作描述

**优化策略**：
- ✅ 使用结构化提示词
- ✅ 明确指定动作时长
- ✅ 使用"motion"参数控制运动幅度

**示例**：
```
Subject: 3D cartoon boy, blue hair, white sweater, brown book
Motion: Gentle idle breathing, chest rises and falls slowly
Camera: Static, no movement
Background: Green screen
Style: Maintain character consistency
Duration: 2 seconds loop
```

**参数设置**：
- Motion: 0.3-0.5（低运动幅度）
- Camera Motion: Off
- Aspect Ratio: 1:1

---

### Kling 1.6 (快手)
**特点**：
- 质量高，角色一致性强
- 支持中英文
- 背景控制较好

**优化策略**：
- ✅ 中英文混合使用
- ✅ 详细描述角色特征
- ✅ 强调"no camera movement"

**示例**：
```
A 3D cartoon boy with blue hair, white sweater, holding brown book,
idle breathing animation, 轻微呼吸动作,
standing in place, 原地站立, no walking,
green screen background, 绿色背景,
smooth loop, 流畅循环, character consistency, 保持角色一致
```

---

### Runway Gen-4
**特点**：
- 最高质量
- 支持非常详细的提示词
- 精确的运动控制

**优化策略**：
- ✅ 使用分段式提示词（角色/动作/相机/背景/技术）
- ✅ 详细描述每个动作阶段
- ✅ 指定精确的时间点

**示例**（结构化）：
```
[Character]
3D stylized boy, blue hair, white sweater, brown book in hands

[Action]
Idle breathing: 0.0-2.0s continuous
- Chest rises (0.0-1.0s)
- Chest falls (1.0-2.0s)
- Shoulders follow chest motion
- Book stays steady in hands

[Camera]
Static front view, no motion, locked position

[Background]
Chroma key green (#00FF00), solid color, no texture

[Technical]
Loop: Seamless start/end
Duration: 2 seconds
Motion: Subtle, natural breathing only
```

---

## 📊 提示词效果对比测试

### 测试方法
对每个工具使用相同的动作，测试3个版本的提示词：

**版本A：简单版**
```
Boy with blue hair, idle animation, green background
```

**版本B：标准版**
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
idle breathing animation, standing in place,
green screen background, smooth loop
```

**版本C：详细版**
```
Character: 3D cartoon boy, blue hair, white sweater, brown book
Action: Idle breathing - chest rises and falls, shoulders move slightly, standing still
Camera: Static front view, no movement
Background: Green screen, solid color
Technical: 2 second loop, seamless, character consistency
```

### 评估标准
1. **角色一致性** (1-5分)
   - 发色、服装、书本是否保持一致
   
2. **背景准确性** (1-5分)
   - 是否是绿色背景
   - 背景是否纯净

3. **动作准确性** (1-5分)
   - 动作是否符合描述
   - 是否原地不动

4. **循环质量** (1-5分)
   - 首尾帧是否相似
   - 是否可以无缝循环

5. **整体质量** (1-5分)
   - 画面流畅度
   - 细节质量

---

## 🎯 提示词优化技巧

### 技巧1：使用参考图
**方法**：上传角色参考图 + 文字提示词

**提示词调整**：
```
Based on the reference image, create an animation of:
[动作描述]
Maintain exact character appearance from reference
Green screen background
```

### 技巧2：分步骤描述
**方法**：将动作分解为多个步骤

**示例（挥手）**：
```
Step 1 (0.0-0.5s): Hand starts at side, begins to raise
Step 2 (0.5-1.0s): Hand reaches shoulder height, starts waving
Step 3 (1.0-1.5s): Hand waves 2-3 times
Step 4 (1.5-2.0s): Hand lowers back to side
Throughout: Other hand holds book, feet stay planted
```

### 技巧3：使用否定词
**方法**：明确说明不要什么

**示例**：
```
NO camera movement
NO walking or running
NO background details
NO style changes
NO character transformation
```

### 技巧4：强调关键词
**方法**：重复重要的要求

**示例**：
```
Green screen background, solid green, chroma key green, pure green background
Standing in place, no walking, feet stay still, stationary position
```

### 技巧5：使用情绪词
**方法**：添加情绪描述增强表现力

**示例**：
```
Happy: joyful, cheerful, bright, energetic
Sad: melancholy, dejected, downcast, gloomy
Angry: furious, tense, stern, intense
```

---

## 📋 提示词模板库

### 通用模板
```
A 3D cartoon boy with blue hair and white sweater, holding a brown book,
[动作描述],
[情绪描述],
standing in place, front view, no walking,
green screen background, solid green color,
smooth looping animation, seamless loop,
maintain character consistency
```

### 中文模板（豆包）
```
蓝发男孩，白色毛衣，手拿棕色书本，
[动作描述]，
[情绪描述]，
原地站立，视角与原图一致，不移动位置，
绿色背景，纯色绿幕，
流畅循环动画，无缝循环，
保持人物完全一致，不改变角色外观
```

### 结构化模板（Runway）
```
[Character]
3D cartoon boy, blue hair, white sweater, brown book

[Action]
[详细动作描述，包含时间点]

[Expression]
[表情描述]

[Camera]
Static front view, no motion

[Background]
Green screen, solid color

[Technical]
Duration: 2s, Loop: seamless, Consistency: high
```

---

## 🔄 迭代优化流程

### 第一次生成
1. 使用标准模板
2. 观察结果
3. 记录问题

### 第二次优化
根据问题调整：
- **角色变化** → 增加角色描述细节，提高一致性要求
- **背景不对** → 多次强调绿色背景
- **动作过大** → 添加"subtle"、"gentle"、"minimal"
- **不循环** → 强调"seamless loop"、"returns to start position"

### 第三次精修
- 使用最佳版本的提示词
- 微调参数（如果工具支持）
- 生成最终版本

---

## 📊 工具选择建议

### 豆包
- ✅ 免费（有限额）
- ✅ 中文友好
- ⚠️ 角色一致性中等
- ⚠️ 背景控制较弱
- **适合**：快速测试、预算有限

### Pika 1.5
- ✅ 价格合理（$10/月）
- ✅ 速度快
- ✅ 角色一致性好
- ✅ 操作简单
- **适合**：快速生产、性价比优先

### Kling 1.6
- ✅ 质量高
- ✅ 角色一致性强
- ✅ 按需付费
- ⚠️ 价格较高
- **适合**：高质量需求、少量使用

### Runway Gen-4
- ✅ 最高质量
- ✅ 最强控制力
- ✅ 专业级效果
- ❌ 价格最贵（$76/月）
- **适合**：商业项目、追求极致质量

---

## 🎯 下一步行动

### 立即执行
1. [ ] 选择一个工具开始测试（推荐Pika或Kling）
2. [ ] 使用优化后的提示词生成Idle动画
3. [ ] 评估效果，记录问题
4. [ ] 迭代优化提示词

### 本周目标
1. [ ] 完成8个动画的提示词优化
2. [ ] 生成所有动画的初版
3. [ ] 选择最佳版本
4. [ ] 提取序列帧

### 后续计划
1. [ ] 去除绿色背景
2. [ ] 统一尺寸和帧率
3. [ ] 转换为Spine格式
4. [ ] 导入游戏引擎测试

---

**创建日期**：2026-01-07  
**状态**：提示词模板已准备，待测试  
**下一步**：选择工具并开始生成测试

