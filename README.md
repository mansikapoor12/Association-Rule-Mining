# **Market Basket Analysis Shiny App**

This repository contains a Shiny web application for performing Market Basket Analysis using association rule mining techniques. The app is designed for interactive data analysis and visualization of relationships between items in transactional data.

1. ## Features

- Upload Transaction Data: Supports CSV and Excel file formats.

- Customizable Parameters:

  - Set minimum support and confidence thresholds for generating association rules.

  - Specify the number of top rules to visualize.

- Interactive Visualizations:

  - Frequency plot of top items.

  - Interactive network graph of association rules.

- Actionable Insights:

  - Suggestions for item pair promotions.

  - Insights into the most impactful association rules.

2. ## How to Use

- Upload Data: The dataset should include the following columns:

  - CustomerID: Unique identifier for customers.

  - InvoiceNo: Transaction ID.

  - StockCode: Item codes or product IDs.

- Set Parameters:

  - Use sliders to adjust the minimum support and confidence thresholds.

  - Specify the number of top rules for visualization.

3. ## Run the Analysis

Click the "Run Analysis" button to generate rules and visualizations.

4. ## Explore Results

View raw data, data summaries, item frequency plots, and rule visualizations.

5. ## Download generated rules in CSV format.

6. ## Files in this Repository

- app.R: The Shiny app script.

- dataset.xlsx (or your dataset file): Sample transactional dataset used for demonstration.

7. ## Getting Started

- Install the required R packages:

**install.packages(c("shiny", "readr", "dplyr", "arules", "arulesViz", "readxl", "igraph", "visNetwork", "shinythemes", "shinycssloaders", "glue"))**
and then run the code using the shiny app feature in RStudio using the code provided.

**Access the deployed app through the following link:**
[Shiny App Deployment Link](https://mansikapoorapps.shinyapps.io/MansiProject/)

8. ## Screenshots:
 - ### Initial interface:
   The app’s user-friendly interface allows users to conduct market basket analysis with ease. Upon launching, the app provides the following features:
   - **File Upload:** Users can upload transaction data in CSV or Excel formats.
   - **Parameter Selection:** The sidebar includes sliders for setting minimum support and confidence thresholds, as well as specifying the number of top rules for visualization.
   - **Action Button:** A simple Run Analysis button initiates the analysis workflow.

The main panel is organized into tabs for better navigation, displaying raw data, data summaries, visualizations, and insights.

![mansiapp](https://github.com/user-attachments/assets/83073b8b-0a7f-440f-a1a3-f7a9f5e6062d)

 - ### Generating Rules:
   The Association Rules tab provides an interactive network graph to visualize the relationships between items in the generated rules.

   - **Nodes:** Represent individual items from the transactions.
   - **Edges:** Represent association rules between items, labeled with their respective lift values.
   - **Interactive Features:** Users can highlight connected nodes and select specific nodes for better insights.
  
This graph helps identify key relationships and dependencies between items in a visually intuitive manner.

![mansiapp2](https://github.com/user-attachments/assets/32c113ea-1d84-4623-adea-b3a416232edb)

 - ### Getting suggestions:
   The Suggestions tab lists actionable insights derived from the top association rules:
It provides a table with columns for:
   - Items in the rule's left-hand side (LHS).
   - Items in the rule's right-hand side (RHS).
   - Support, confidence, and lift values of each rule.
A Suggestions column offering marketing recommendations, such as:
“Promote LHS items together with RHS items to increase sales.”

This section serves as a practical guide for businesses to implement data-driven strategies for product promotion and bundling. 

![mansiapp3](https://github.com/user-attachments/assets/4c22b105-9cea-4512-8e50-201a1b55ccb7)


9. ## License

This project is open-source and available under the MIT License.
