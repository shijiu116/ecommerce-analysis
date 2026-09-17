# 电商用户行为分析（eCommerce behavior data from multi category store）

基于阿里天池公开的电商用户行为数据集（900万+条事件记录），使用 MySQL 完成数据清洗与深度分析，Power BI 搭建交互式仪表盘，定位用户转化瓶颈并输出运营策略建议。

## 项目背景

电商平台普遍面临两个核心问题：

1. **用户转化路径长**：从浏览到下单，中间流失严重，但缺乏量化分析
2. **高价值用户识别难**：无法区分谁是真正贡献利润的核心用户

本项目基于真实电商行为数据，构建从数据获取、清洗、分析到可视化的完整链路，为运营策略提供数据支持。

## 技术栈

| 工具 | 用途 |
|------|------|
| MySQL | 数据导入、清洗、多表关联、窗口函数分析 |
| Power BI | 数据建模、DAX 度量值、交互式仪表盘 |

## 数据来源

- **数据集名称**：eCommerce behavior data from multi category store（2019.10）
- **来源**：阿里天池公开数据集（搬运自 Kaggle）
- **数据集地址**：https://tianchi.aliyun.com/dataset/（请补充你截图里对应的具体链接）
- **原始来源**：https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store
- **数据时间范围**：2019 年 10 月
- **记录数**：900 万+ 条用户事件
- **数据规模**：约 10GB（未压缩 CSV），天池提供文件约 1.12GB
- **事件类型**：浏览（view）、加购（cart）、移除购物车（remove_from_cart）、购买（purchase）
- **数据特点**：以 `user_session` 作为唯一键进行数据处理

### 字段说明（Data Dictionary）

| 字段 | 类型 | 说明 |
|------|------|------|
| event_time | 时间戳 | 事件发生时间（UTC） |
| event_type | 字符串 | view / cart / remove_from_cart / purchase |
| product_id | 整数 | 商品 ID |
| category_id | 整数 | 商品类目 ID |
| category_code | 字符串 | 商品类目编码（如 electronics.smartphone） |
| brand | 字符串 | 品牌名称 |
| price | 浮点数 | 商品价格 |
| user_id | 整数 | 用户 ID |
| user_session | 字符串 | 用户会话 ID（唯一键） |

> 原始数据文件约 1.12GB，请从天池数据集页面下载 `ecommerce_events.csv`。下载后按 `sql/01_create_table.sql` 中的说明导入 MySQL。

## 分析模块

### 1. 整体经营概览
统计平台总用户数、总会话数、总商品数、总类目数，以及浏览、加购、移除购物车、购买四类事件的次数分布，并计算整体转化率与客单价。

### 2. 用户行为转化漏斗
构建「浏览 → 加购 → 购买」的用户级转化漏斗，计算各环节转化率，定位主要流失环节。

### 3. RFM 用户价值分层
基于用户的最近购买时间（R）、购买频率（F）、消费金额（M）三个维度，使用 `NTILE(4)` 窗口函数进行独立评分，划分：
- 高价值用户
- 新客 / 潜力用户
- 流失预警用户
- 一般 / 流失用户

### 4. 用户留存分析
基于用户首次活跃日期，计算整体次日留存率与 7 日留存率，评估用户粘性。

### 5. 商品与品牌分析
- 购买次数 TOP20 商品排名
- 品牌销售占比分布（TOP20 品牌）
-销售额TOP20商品排名

### 6. 时间维度分析
- 24 小时用户活跃趋势与购买转化率
- 每日活跃用户趋势

## 核心发现

- 用户活跃高峰集中在 **6：00-11：00**，该时段事件量最大，转化率最高
- 「加购 → 购买」环节转化率仅约 **30.91%**，是主要流失环节
- 高价值用户占比约 **23.09%**，贡献了平台大部分 GMV
- 次日留存率约 **4.70%**，7 日留存率约 **2.49%**
- 没有少数品牌撑起大盘，平台是长尾市场


## 项目结构

ecommerce-user-behavior-analysis/
├── README.md 项目说明
├── sql/ SQL 脚本
│ ├── 01_ 建库建表.sql
│ ├── 02_ 数据清洗.sql
│ ├── 03_ 整体经营概览.sql
│ ├── 04_ 转化漏斗分析.sql
│ ├── 05_ RFM 用户分层.sql
│ ├── 06_ 留存分析.sql
│ ├── 07_ 商品与品牌 TOP20.sql
│ ├── 08_ 时间维度分析.sql
├── powerbi/
│ └── ecommerce_dashboard.pbix Power BI 仪表盘
├── images/ 仪表盘截图
│ ├── page1_overview.png
│ ├── page2_user.png
│ ├── page3_product.png
│ └── page4_time.png
└── data/
└── README.md 数据源说明


## 仪表盘预览

### 第 1 页 · 经营总览
![经营总览](images/page1_overview.png)

### 第 2 页 · 用户行为分析
![用户分析](images/page2_user.png)

### 第 3 页 · 商品与品牌分析
![商品分析](images/page3_product.png)

### 第 4 页 · 时间与价格分析
![时间分析](images/page4_time.png)

## 如何运行

1. 从天池数据集页面下载 `ecommerce_events.csv`（数据集链接见上方）
2. 在 MySQL 中依次执行 `sql/` 目录下的脚本（按编号顺序）
3. 用 Power BI Desktop 打开 `powerbi/ecommerce_dashboard.pbix`
4. 如需重新连接数据源，在 Power BI 中「转换数据 → 数据源设置」修改 MySQL 连接信息

## 环境要求

- MySQL 8.0+
- Power BI Desktop（2023 年及以后版本）
- 建议内存 8GB 以上（处理百万级数据）

## 与 UserBehavior 数据集的对比

本项目使用的新数据集相比经典的 UserBehavior 数据集有以下优势：

| 维度 | UserBehavior | eCommerce behavior data |
|------|--------------|-------------------------|
| 记录数 | 900万+条 | 900 万+条 |
| 是否含价格 | 否 | ✅ 含 price 字段 |
| 是否含品牌 | 否 | ✅ 含 brand 字段 |
| 是否含类目名称 | 否（只有 ID） | ✅ 含 category_code |
| 是否含会话 ID | 否 | ✅ 含 user_session |
| 事件类型 | pv/fav/cart/buy | view/cart/remove_from_cart/purchase |


## 作者

习惯
- GitHub：https://github.com/shijiu116- 邮箱：2758005413@qq.com

## 许可证

本项目仅用于学习与作品展示，数据集版权归阿里天池、Kaggle 及原始提供方所有。