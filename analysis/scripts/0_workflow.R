DiagrammeR("graph TB
            A[PROPOSED WORKFLOW]-->B[Object-based Image Analysis]
            A[PROPOSED WORKFLOW]-->C[Pixel-based Image Analysis]
            B[Object-based Image Analysis]-->|LiDAR data|D[CHM]
            D[CHM]-->|test segmentation values|E[CENITH::TreeSeg]
            D[CHM]-->|test on test area 1|F[CENITH::BestSegVal]
            E[CENITH::TreeSeg]-->F[CENITH::BestSegVal]
            F[CENITH::BestSegVal]-->|test on all 4 test areas|G[CENITH::TreeSegCV]
            G[CENITH::TreeSegCV]-->|apply best result to ROI |H[CENITH::TreeSeg]
            C[Pixel-based Image Analysis]-->|AERIAL IMAGERY|I[LEGION::vegInd_RGB + LEGION::vegInd_mspec]
            I[LEGION::vegInd_RGB + LEGION::vegInd_mspec]-->J[LEGION::detct_RstHmgy]
            J[LEGION::detct_RstHmgy]-->K[LEGION::filter_Stk]
            K[LEGION::filter_Stk]-->L[LEGION::detct_RstCor]
            L[LEGION::detct_RstCor]-->M[IKARUS::exrct_Traindat]
            M[IKARUS::exrct_Traindat]-->N[IKARUS::BestPredFFS]
            N[IKARUS::BestPredFFS]-->O[IKARUS::RFclass]
            I[LEGION::vegInd_RGB + LEGION::vegInd_mspec]-->|create predictors|L[LEGION::detct_RstCor]
            L[LEGION::detct_RstCor]-->|prepare classification|N[IKARUS::BestPredFFS]
            H[CENITH::TreeSeg]-->P[IKARUS::classSegVal]
            O[IKARUS::RFclass]-->P[IKARUS::classSegVal]

            style A fill:#d5f4e6, stroke:#000000, stroke-width:4px
            linkStyle 0 stroke-width:4px, fill:none, stroke:#618685
            style B fill:#d5f4e6, stroke:#618685, stroke-width:4px
            linkStyle 1 stroke-width:4px, fill:none, stroke:#618685
            style C fill:#d5f4e6, stroke:#618685, stroke-width:4px
            linkStyle 2 stroke-width:2px, fill:none, stroke:#618685
            style D fill:#d5f4e6, stroke:#618685, stroke-width:2px, stroke-dasharray: 5 5
            linkStyle 3 stroke-width:2px, fill:none, stroke:#618685
            style E fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 4 stroke-width:4px, fill:none, stroke:#618685
            style F fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 5 stroke-width:2px, fill:none, stroke:#618685
            style G fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 6 stroke-width:4px, fill:none, stroke:#618685
            style H fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 7 stroke-width:4px, fill:none, stroke:#618685
            style I fill:#d5f4e6, stroke:#618685, stroke-width:2px, stroke-dasharray: 5 5
            linkStyle 8 stroke-width:2px, fill:none, stroke:#618685
            style J fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 9 stroke-width:2px, fill:none, stroke:#618685
            style K fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 10 stroke-width:2px, fill:none, stroke:#618685
            style L fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 11 stroke-width:2px, fill:none, stroke:#618685
            style M fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 12 stroke-width:2px, fill:none, stroke:#618685
            style N fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 13 stroke-width:2px, fill:none, stroke:#618685
            style O fill:#d5f4e6, stroke:#618685, stroke-width:2px
            linkStyle 14 stroke-width:2px, fill:none, stroke:#618685
            style P fill:#d5f4e6, stroke:#618685, stroke-width:4px
            linkStyle 15 stroke-width:4px, fill:none, stroke:#618685
            linkStyle 16 stroke-width:4px, fill:none, stroke:#618685
            linkStyle 17 stroke-width:4px, fill:none, stroke:#618685
            linkStyle 18 stroke-width:4px, fill:none, stroke:#618685")
