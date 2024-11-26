**Market Basket Analysis Shiny App**

This repository contains a Shiny web application for performing Market Basket Analysis using association rule mining techniques. The app is designed for interactive data analysis and visualization of relationships between items in transactional data.

Features

-Upload Transaction Data: Supports CSV and Excel file formats.

-Customizable Parameters:

-->Set minimum support and confidence thresholds for generating association rules.

-->Specify the number of top rules to visualize.

-Interactive Visualizations:

-->Frequency plot of top items.

-->Interactive network graph of association rules.

-Actionable Insights:

-->Suggestions for item pair promotions.

-->Insights into the most impactful association rules.

How to Use

-Upload Data: The dataset should include the following columns:

-->CustomerID: Unique identifier for customers.

-->InvoiceNo: Transaction ID.

-->StockCode: Item codes or product IDs.

-Set Parameters:

-->Use sliders to adjust the minimum support and confidence thresholds.

-->Specify the number of top rules for visualization.

Run the Analysis:

-Click the "Run Analysis" button to generate rules and visualizations.

Explore Results:

-View raw data, data summaries, item frequency plots, and rule visualizations.

Download generated rules in CSV format.

Files in this Repository

-app.R: The Shiny app script.

-dataset.xlsx (or your dataset file): Sample transactional dataset used for demonstration.

Getting Started

-Install the required R packages:

**install.packages(c("shiny", "readr", "dplyr", "arules", "arulesViz", "readxl", "igraph", "visNetwork", "shinythemes", "shinycssloaders", "glue"))**

**Access the deployed app through the following link:**
[Shiny App Deployment Link](https://mansikapoorapps.shinyapps.io/MansiProject/)

Screenshots:
1. Initial interface: 
![mansiapp](https://github.com/user-attachments/assets/83073b8b-0a7f-440f-a1a3-f7a9f5e6062d)

2. Generating Rules:
![mansiapp2](https://github.com/user-attachments/assets/32c113ea-1d84-4623-adea-b3a416232edb)

3. Getting suggestions:
![mansiapp3](https://github.com/user-attachments/assets/4c22b105-9cea-4512-8e50-201a1b55ccb7)


License
This project is open-source and available under the MIT License.
