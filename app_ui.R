library(shinydashboard)

source("scripts/credential_filing.R")


# Main login screen
loginpage <- div(id = "loginpage", style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
                 wellPanel(
                   tags$h2("LOG IN", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
                   textInput("userName", placeholder="Username", label = tagList(icon("user"), "Username")),
                   passwordInput("passwd", placeholder="Password", label = tagList(icon("unlock-alt"), "Password")),
                   br(),
                   div(
                     style = "text-align: center;",
                     actionButton("login", "SIGN IN", style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
                     actionButton("new_user", "New User",style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
                     shinyjs::hidden(
                       div(id = "nomatch",
                           tags$p("Oops! Incorrect username or password!",
                                  style = "color: red; font-weight: 600; 
                                            padding-top: 5px;font-size:16px;", 
                                  class = "text-center"))),
                   ))
)

rest_add_page <- div(id = "rest_add_page", style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
                     wellPanel(
                       textInput("rest_name", placeholder = "Restroom Name", label = tagList(icon("toilet"), "Restroom Name")),
                       textInput("rest_addy", placeholder = "Restroom Address", label = tagList(icon("toilet"), "Restroom Address")),
                       br(),
                       div(
                         style = "text-aligh: center;",
                         actionButton("submit_rest", "Submit"),
                         shinyjs::hidden(
                           div(id = "rest_submitted",
                               tags$p("Restroom Submited and added",
                                      style = "color: red; font-weight: 600; 
                                            padding-top: 5px;font-size:16px;", 
                                      class = "text-center"))),
                       )
                     )
)

create_user_page <- div(id = "create_user_page", style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
                        wellPanel(
                          textInput("new_username", placeholder = "Username", label = tagList(icon("user"), "Username")),
                          passwordInput("new_pass", placeholder = "Password", label = tagList(icon("user"), "Password")),
                          passwordInput("confirm_pass", placeholder = "Confirm Password", label = tagList(icon("user"), "Confirm Password")),
                        ),
                        br(),
                        div(
                          style = "text-align: center;",
                          actionButton("create", "Create New User"),
                          shinyjs::hidden(
                            div(id = "duplicate",
                                tags$p("Username Already Taken",
                                       style = "color: red; font-weight: 600; 
                                            padding-top: 5px;font-size:16px;", 
                                       class = "text-center"))),
                          shinyjs::hidden(
                            div(id = "no_match",
                                tags$p("Passwords do not match",
                                       style = "color: red; font-weight: 600; 
                                            padding-top: 5px;font-size:16px;", 
                                       class = "text-center"))),
                        )
                        )

header <- dashboardHeader( title = "under construction", uiOutput("logoutbtn"))

sidebar <- dashboardSidebar(uiOutput("sidebarpanel")) 
body <- dashboardBody(shinyjs::useShinyjs(), uiOutput("body"))
ui<-dashboardPage(header, sidebar, body, skin = "blue")
