# lead-intelligence-optimizer
An end-to-end B2B data pipeline and machine learning scoring system that identifies high-intent prospects and predicts conversion probabilities. This system shifts sales focus from traditional firmographic "Big Names" to dynamic behavioral triggers, optimizing outreach efficiency.

##  Business Problem & Impact
The sales team was overwhelmed by a volume of 2,500 leads with a low baseline conversion rate of 5.21%. High-value sales development representatives (SDRs) spent excessive time on low-intent enterprise tech leads, while high-converting, time-sensitive leads went cold due to delayed response times.

**Key Achievements:**
* **Model Performance:** Achieved an **ROC-AUC of 0.84** for ranking lead quality.
* **Insight Discovery:** Uncovered the "Title Trap"—proving that dynamic behavioral velocity outperforms traditional static metrics like Job Title by **2x**.
* **Revenue Driver:** Identified a conversion "strike zone" in Mid-Market Education (8.93% conversion rate) and Small Healthcare (8.55% conversion rate).

## Tech Stack & Architecture
* **Data Extraction & Feature Engineering:** MySQL (Multi-layered analytical queries tracking Velocity and Recency).
* **Predictive Modeling:** Python (XGBoost, Scikit-Learn).
* **Model Explainability:** SHAP (Shapley Additive exPlanations).
* **Business Intelligence:** Tableau (Executive KPI Tracking & Interactive Behavioral Scatter Plots).

##  Key Insights & Model Analytics

## 1. General Observation
I observed that your company's conversion "sweet spot" is an Education or Healthcare lead who arrived via a Webinar, has viewed the Pricing Page 2+ times, and is moving with a Velocity Score above 4.0. Conversely, you are losing significant efficiency by chasing large Tech firms and leads that have gone "cold" beyond 40 days without action. 

### 2. Feature Importance (SHAP Explainability)
The XGBoost model highlighted a major operational bottleneck:
* **`Days Since Last Action` (Recency):** The number one feature driving conversion decline. Leads decay rapidly if left uncontacted past 14 days.
* **`Pricing Page Views`:** A high-velocity indicator of intent. Two or more pricing page views serve as a much stronger conversion signal than routine whitepaper or content downloads.

### 3. The Model Performance Trade-Off
While the model boasts a strong **ROC-AUC of 0.84** (making it exceptional at ranking the absolute best leads for the "Daily Hot List"), the current **Recall for Class 1 stands at 0.27**. 
* *Operational Execution:* The system safely isolates the top 25% of absolute high-converting "strike zone" leads for immediate routing to senior account executives, while the remaining population is systematically funneled into automated marketing nurture paths.

## Visuals
[Dashboard1] (https://github.com/akandug/lead-intelligence-optimizer/blob/main/leaddashboard1.PNG)

[Dashboard2] ()

##  Strategic Recommendations Implemented
1. **Automate Speed-to-Lead:** Instantly route leads with a Behavioral Velocity Score > 2.5 and 2+ Pricing Page views to Senior AEs with an SLA of under 1 hour.
2. **Budget Reallocation:** Shift 20% of the marketing acquisition budget away from large Enterprise Tech and into Webinar acquisition channels targeting Education and Healthcare sectors.
3. **Automate Re-engagement:** Trigger an automated nurture campaign at Day 10 of inactivity rather than waiting for the prospect to hit the 30-day "Cold" threshold.
