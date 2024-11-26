#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

options(repos = c(CRAN = "https://cran.rstudio.com/"))


# Required Libraries
library(shiny)
library(readr)
library(dplyr)
library(arules)
library(arulesViz)
library(readxl)
library(igraph)
library(visNetwork)
library(shinythemes)
library(shinycssloaders)
library(glue)

# Define UI
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  titlePanel("Market Basket Analysis App"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload Transaction Data (CSV/Excel)",
                accept = c(".csv", ".xlsx")),
      sliderInput("support", "Minimum Support", min = 0, max = 1, value = 0.01, step = 0.01),
      sliderInput("confidence", "Minimum Confidence", min = 0, max = 1, value = 0.8, step = 0.01),
      numericInput("topN", "Top N Rules for Visualization", value = 5, min = 1, max = 50),
      actionButton("run", "Run Analysis"),
      downloadButton("downloadRules", "Download Rules")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Raw Data", tableOutput("rawData") %>% withSpinner()),
        tabPanel("Data Summary", tableOutput("dataSummary") %>% withSpinner()),
        tabPanel("Item Frequency Plot", plotOutput("freqPlot") %>% withSpinner()),
        tabPanel("Association Rules", visNetworkOutput("ruleGraph") %>% withSpinner()),
        tabPanel("Suggestions", tableOutput("suggestions") %>% withSpinner()),
        tabPanel("Insights", textOutput("insights") %>% withSpinner())
      )
    )
  )
)

# Define Server
server <- function(input, output) {
  observeEvent(input$run, {
    req(input$file)
    
    # Load and preprocess data
    ext <- tools::file_ext(input$file$name)
    data <- if (ext == "csv") {
      read_csv(input$file$datapath)
    } else if (ext == "xlsx") {
      read_excel(input$file$datapath)
    } else {
      showNotification("Invalid file type. Please upload a CSV or Excel file.", type = "error")
      return()
    }
    
    # Validate data
    if (!all(c("CustomerID", "StockCode", "InvoiceNo") %in% names(data))) {
      showNotification("Required columns (CustomerID, StockCode, InvoiceNo) are missing.", type = "error")
      return()
    }
    
    # Preprocess data
    data <- data %>%
      filter(!is.na(CustomerID), !is.na(StockCode)) %>%
      distinct()
    
    transactions <- as(split(data$StockCode, data$InvoiceNo), "transactions")
    
    # Tab: Raw Data
    output$rawData <- renderTable({
      head(data)
    })
    
    # Tab: Data Summary
    output$dataSummary <- renderTable({
      num_transactions <- length(transactions)
      num_items <- length(itemLabels(transactions))
      transaction_sizes <- size(transactions)
      
      data.frame(
        Metric = c("Number of Transactions", "Number of Unique Items", "Average Items per Transaction"),
        Value = c(num_transactions, num_items, round(mean(transaction_sizes), 2))
      )
    })
    
    # Tab: Item Frequency Plot
    output$freqPlot <- renderPlot({
      itemFrequencyPlot(transactions, topN = 10, type = "absolute", col = "steelblue", main = "Top 10 Item Frequencies")
    })
    
    # Generate Association Rules
    rules <- apriori(transactions, parameter = list(supp = input$support, conf = input$confidence))
    
    # Tab: Association Rules (Network Graph)
    output$ruleGraph <- renderVisNetwork({
      if (length(rules) > 0) {
        top_rules <- sort(rules, by = "lift", decreasing = TRUE)[1:input$topN]
        rules_df <- as(top_rules, "data.frame")
        rules_df$lhs <- sapply(as(top_rules@lhs, "list"), function(x) paste(x, collapse = ", "))
        rules_df$rhs <- sapply(as(top_rules@rhs, "list"), function(x) paste(x, collapse = ", "))
        
        nodes <- data.frame(
          id = unique(c(rules_df$lhs, rules_df$rhs)),
          label = unique(c(rules_df$lhs, rules_df$rhs)),
          stringsAsFactors = FALSE
        )
        
        edges <- data.frame(
          from = rules_df$lhs,
          to = rules_df$rhs,
          label = paste0("Lift: ", round(rules_df$lift, 2)),
          stringsAsFactors = FALSE
        )
        
        visNetwork(nodes, edges) %>%
          visNodes(color = list(background = "skyblue", border = "black")) %>%
          visEdges(color = "gray") %>%
          visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)
      } else {
        showNotification("No rules generated to display a graph.", type = "error")
        NULL
      }
    })
    
    # Tab: Suggestions
    output$suggestions <- renderTable({
      if (length(rules) > 0) {
        top_rules <- sort(rules, by = "lift", decreasing = TRUE)[1:input$topN]
        rules_df <- as(top_rules, "data.frame")
        rules_df$lhs <- sapply(as(top_rules@lhs, "list"), function(x) paste(x, collapse = ", "))
        rules_df$rhs <- sapply(as(top_rules@rhs, "list"), function(x) paste(x, collapse = ", "))
        
        rules_df %>%
          mutate(Suggestions = paste0("Promote ", lhs, " with ", rhs)) %>%
          select(lhs, rhs, support, confidence, lift, Suggestions)
      } else {
        showNotification("No rules generated to create suggestions.", type = "error")
        NULL
      }
    })
    
    # Tab: Insights
    output$insights <- renderText({
      if (length(rules) > 0) {
        # Get the top rule by lift
        top_rule <- sort(rules, by = "lift", decreasing = TRUE)[1]
        
        # Extract lhs and rhs using labels() for S4 compatibility
        lhs <- labels(lhs(top_rule))[1]
        rhs <- labels(rhs(top_rule))[1]
        
        # Extract quality metrics
        support <- quality(top_rule)$support[1]
        confidence <- quality(top_rule)$confidence[1]
        lift <- quality(top_rule)$lift[1]
        
        # Construct the insight message
        glue("The most impactful rule is: Customers who purchase {lhs} are likely to purchase {rhs}. 
          This rule has a support of {round(support, 2)}, confidence of {round(confidence, 2)}, 
          and a lift of {round(lift, 2)}.")
      } else {
        "No rules were generated."
      }
    })
    
    # Download Rules
    output$downloadRules <- downloadHandler(
      filename = function() { "association_rules.csv" },
      content = function(file) {
        write.csv(as(rules, "data.frame"), file)
      }
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
