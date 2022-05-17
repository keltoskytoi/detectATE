#general workflow
mermaid("graph TB
        A[dataset]-->B[Data Preparation]
        B[Data Preparation]-.->|CHM generation|C[SEGMENTATION]
        B[Data Preparation]-.->|Prediction 1|D[CLASSIFICATION]

        style A fill:#FFF, stroke:#333, stroke-width:2px
        style B fill:#5F9EA0, stroke:#2F4F4F, stroke-width:2px
        style C fill:#d5f4e6, stroke:#618685, stroke-width:2px
        style D fill:#d5f4e6, stroke:#618685, stroke-width:2px")

        B[Decision Tree 1]-.->|Prediction 1|E[majority voting/averaging]
        C[Decision Tree 2]-.->|Prediction 2|E[majority voting/averaging]
        D[Decision Tree n]-.->|Prediction n|E[majority voting/averaging]
        E[majority voting/averaging]-->F[final prediction]
