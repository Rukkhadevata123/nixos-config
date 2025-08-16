
# 📜 **Mermaid 模板库**

## 1. 技术架构图（横向流程图）

```mermaid
flowchart LR
    subgraph 客户端
        A[Web Browser] --> B[Mobile App]
    end
    subgraph 服务端
        C[API Gateway] --> D[微服务1]
        C --> E[微服务2]
        D --> F[(数据库)]
    end
    A --> C
    B --> C
```

## 2. 系统部署拓扑（竖向流程图）

```mermaid
flowchart TD
    A[负载均衡器] --> B[Server 1]
    A --> C[Server 2]
    A --> D[Server 3]
    B -->|NFS| E[(共享存储)]
    C -->|NFS| E
    D -->|NFS| E
```

## 3. CI/CD 流水线（横向时序）

```mermaid
sequenceDiagram
    participant 开发者
    participant GitLab
    participant Runner
    participant K8s

    开发者->>GitLab: git push
    GitLab->>Runner: 触发 Pipeline
    Runner->>K8s: 构建镜像并部署
    K8s-->>Runner: 状态反馈
    Runner-->>GitLab: 报告结果
    GitLab-->>开发者: 邮件通知
```

## 4. 数据库关系图（ER 图）

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    PRODUCT ||--|{ LINE-ITEM : includes
    CUSTOMER {
        int id PK
        string name
        string email
        date registered
    }
    ORDER {
        int id PK
        date created
        float total_amount
        string status
    }
    PRODUCT {
        int id PK
        string name
        float price
        int stock
    }
    LINE-ITEM {
        int id PK
        int quantity
        float price
    }
```

## 5. Kubernetes Pod 生命周期

```mermaid
stateDiagram-v2
    [*] --> Pending
    Pending --> Running: 调度成功
    Running --> Succeeded: 任务完成
    Running --> Failed: 执行错误
    Running --> CrashLoopBackOff: 持续崩溃
    CrashLoopBackOff --> Running: 修复后
```

## 6. 网络协议栈对比（横向对比图）

```mermaid
graph LR
    subgraph TCP/IP
        A[HTTP] --> B[TCP]
        B --> C[IP]
        C --> D[Ethernet]
    end
    subgraph RDMA
        E[Verbs API] --> F[IB/RoCE]
    end
```

## 7. 监控告警流程（甘特图）

```mermaid
gantt
    title 告警响应时间线
    dateFormat  HH:mm
    section 故障发现
    Prometheus 检测       :a1, 09:00, 2m
    section 告警处理
    发送邮件通知         :a2, after a1, 5m
    运维人员响应        :a3, after a2, 15m
    section 恢复验证
    服务自愈           :a4, after a3, 10m
```

## 8. 用户权限体系（类图）

```mermaid
classDiagram
    class User {
        +String username
        +String password
        +login()
    }
    class Admin {
        +manageUsers()
    }
    class Guest {
        +viewOnly()
    }
    User <|-- Admin
    User <|-- Guest
```

## 9. 决策树（横向流程图）

```mermaid
graph LR
    Start --> ConditionA{条件A}
    ConditionA -->|是| Action1[操作1]
    ConditionA -->|否| ConditionB{条件B}
    ConditionB -->|是| Action2[操作2]
    ConditionB -->|否| Action3[操作3]
```

## 10. 服务器状态统计（饼图）

```mermaid
pie
    title 服务器负载分布
    "正常" : 75
    "警告" : 15
    "故障" : 10
```

## 11. 用户交互流程（顺序图）

```mermaid
sequenceDiagram
    actor 用户
    participant 前端
    participant API服务
    participant 数据库
    
    用户->>前端: 提交表单
    前端->>API服务: POST /api/submit
    API服务->>数据库: 写入数据
    数据库-->>API服务: 返回结果
    API服务-->>前端: 200 OK
    前端-->>用户: 显示成功消息
```

## 12. 项目里程碑（时间线）

```mermaid
timeline
    title 项目关键里程碑
    section 规划阶段
        需求收集 : 2025-01
        系统设计 : 2025-02
    section 开发阶段
        核心功能开发 : 2025-03 ~ 2025-05
        内部测试 : 2025-06
    section 发布阶段
        公测 : 2025-07
        正式发布 : 2025-08
```

## 13. 业务流程图（泳道图）

```mermaid
flowchart TD
    subgraph 客户
        A[提出需求] --> B{是否明确?}
        B -->|是| C[签订合同]
        B -->|否| A
    end
    subgraph 开发团队
        D[需求分析] --> E[系统设计]
        E --> F[编码实现]
        F --> G[单元测试]
    end
    subgraph 测试团队
        H[系统测试] --> I{通过?}
        I -->|是| J[准备发布]
        I -->|否| F
    end
    C --> D
    G --> H
```

## 14. 项目优先级矩阵

```mermaid
graph TD
    subgraph 高收益
        A[用户认证功能]
        B[数据分析仪表盘]
        C[API Gateway]
    end
    subgraph 低收益
        D[社交媒体集成]
        E[多语言支持]
    end
    
    classDef highCostHighValue fill:#f9d,stroke:#333,stroke-width:2px
    classDef lowCostHighValue fill:#bfb,stroke:#333,stroke-width:2px
    classDef highCostLowValue fill:#fbb,stroke:#333,stroke-width:2px
    classDef lowCostLowValue fill:#ddd,stroke:#333,stroke-width:1px
    
    class B,D highCostHighValue
    class A,C lowCostHighValue
    class D highCostLowValue
    class E lowCostLowValue
```

## 15. 思维导图

```mermaid
mindmap
    root((项目管理))
        规划
            需求分析
            资源分配
            时间表
        执行
            任务分配
            进度跟踪
            质量控制
        监控
            数据收集
            报告生成
        收尾
            验收测试
            文档归档
```

## 16. 组织架构图

```mermaid
graph TD
    CEO[首席执行官] --- CTO[技术总监]
    CEO --- CFO[财务总监]
    CEO --- COO[运营总监]
    CTO --- 前端[前端开发团队]
    CTO --- 后端[后端开发团队]
    CTO --- 测试[质量测试团队]
    COO --- 市场[市场部]
    COO --- 客服[客户服务]
    CFO --- 财务[财务部]
    
    classDef executive fill:#f9d,stroke:#333,stroke-width:2px
    classDef department fill:#bbf,stroke:#333,stroke-width:1px
    class CEO,CTO,CFO,COO executive
    class 前端,后端,测试,市场,客服,财务 department
```

## 17. 组合图表（混合使用多种图表）

```mermaid
graph TB
    subgraph 前端应用
        A[Web UI]
        B[Mobile App]
    end
    subgraph 后端服务
        C[(数据库)]
        D{API网关}
        E[认证服务]
        F[业务逻辑]
    end
    A --> D
    B --> D
    D --> E
    D --> F
    E --> C
    F --> C
    
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#fcf,stroke:#333,stroke-width:2px
    style C fill:#9cf,stroke:#333,stroke-width:2px
    style D fill:#fd8,stroke:#333,stroke-width:2px
    style E fill:#cfc,stroke:#333,stroke-width:2px
    style F fill:#cfc,stroke:#333,stroke-width:2px
```

## 18. 主题配置与样式美化

```mermaid
%%{init: {
  'theme': 'base',
  'themeVariables': {
    'primaryColor': '#BB2528',
    'primaryTextColor': '#fff',
    'primaryBorderColor': '#7C0000',
    'lineColor': '#F8B229',
    'secondaryColor': '#006100',
    'tertiaryColor': '#fff'
  }
}}%%
flowchart LR
    A[开始] -->|触发| B{条件判断}
    B -->|满足| C[处理]
    B -->|不满足| D[跳过]
    C --> E[结束]
    D --> E
```

## 19. Git分支管理流程

```mermaid
gitGraph:
    commit id:"初始提交"
    branch develop
    checkout develop
    commit id:"功能开发"
    branch feature
    checkout feature
    commit id:"新功能1"
    commit id:"新功能2"
    checkout develop
    merge feature
    commit id:"准备发布"
    checkout main
    merge develop tag:"v1.0.0"
    branch hotfix
    checkout hotfix
    commit id:"紧急修复"
    checkout main
    merge hotfix tag:"v1.0.1"
    checkout develop
    merge hotfix
```

## 20. C4模型系统上下文图

```mermaid
flowchart TD
    U[用户] -->|使用| S[系统]
    S -->|调用| P[支付网关]
    S -->|发送| E[邮件服务]
    S -->|存储| D[(数据库)]
    
    classDef user fill:#08427b,stroke:#052e56,color:#fff
    classDef system fill:#1168bd,stroke:#0b4884,color:#fff
    classDef external fill:#999999,stroke:#6b6b6b,color:#fff
    classDef database fill:#438dd5,stroke:#2e6295,color:#fff
    
    class U user
    class S system
    class P,E external
    class D database
```

---

### 🎯 **使用技巧**

1. **快速修改**  
   - 替换 `[]` 中的文本即可适配您的场景  
   - 调整方向：`LR`（左→右）、`TD`/`TB`（上→下）、`RL`（右→左）

2. **样式美化**  
   在图表开头添加主题配置：

   ```plaintext
   %%{init: {'theme': 'forest'}}%%
   graph LR
       A[Green Node] --> B[Blue Node]
   ```

   ```mermaid
   %%{init: {'theme': 'forest'}}%%
   graph LR
       A[Green Node] --> B[Blue Node]
   ```

   支持主题：`default`/`forest`/`dark`/`neutral`

3. **组合使用**  
   用 `subgraph` 嵌套多个图表模块，例如同时展示物理机和容器部署：

   ```plaintext
   graph TB
       subgraph 物理机
           A[Server] --> B[NFS]
       end
       subgraph Kubernetes
           C[Pod] --> D[PVC]
       end
       B --> D
   ```

   ```mermaid
   graph TB
       subgraph 物理机
           A[Server] --> B[NFS]
       end
       subgraph Kubernetes
           C[Pod] --> D[PVC]
       end
       B --> D
   ```

4. **兼容性提示**  
   - 某些高级图表类型如`quadrantChart`可能在不同渲染器中兼容性不同
   - 遇到渲染问题时，可使用标准流程图配合样式实现类似效果

---

### 📂 **模板保存建议**

1. 创建 mermaid_templates.md 文件存放这些模板  
2. 在 VS Code 中安装 **Mermaid Preview** 插件实时调试  
3. 团队共享时，推荐用 GitLab/GitHub 的 Markdown 渲染能力
