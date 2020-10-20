library(dplyr) 


source("scripts/restroom_map.R")
source("scripts/mapping.R")
source("scripts/credential_filing.R")


server <- function(input, output, session) {
  
  login = FALSE
  creating = FALSE
  permission = "basic"
  user_id <- ""
  USER <- reactiveValues(login = login, permission = "basic", id = user_id )
  CREATE <- reactiveValues(creating = creating)
  
  observe({ 
    if (USER$login == FALSE) {
      if (!is.null(input$login)) {
        if (input$login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          if(length(which(credentials$username==Username))==1) { 
            pasmatch  <- credentials["passod"][which(credentials$username==Username),]
            pasverify <- password_verify(unlist(pasmatch), Password)
            if(pasverify) {
              USER$login <- TRUE
              USER$permission <- credentials["permission"][which(credentials$username==Username),]
              USER$id <- credentials["username_id"][which(credentials$username==Username),]
            } else {
              shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
              shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
            }
          } else {
            shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
            shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
          }
        } 
      }
    }    
  })
  
  observeEvent(input$submit_rest,{
      rest_name <- isolate(input$rest_name)
      rest_addy <- isolate(input$rest_addy)
      add_restroom(rest_name, rest_addy)
      shinyjs::delay(3000, shinyjs::toggle(id = "rest_submitted", anim = TRUE, time = 1, animType = "fade"))
  })
  
  
  observeEvent(input$new_user,{
    CREATE$creating = TRUE
  })
  
  observeEvent(input$create, {
    new_user <- isolate(input$new_username)
    new_pass <- isolate(input$new_pass)
    confirm <- isolate(input$confirm_pass)
    if(new_pass == confirm) {
        add_user(new_user, new_pass)
        CREATE$creating = FALSE
        loginpage
    } else {
      shinyjs::toggle(id = "no_match", anim = TRUE, time = 1, animType = "fade")
      shinyjs::delay(3000, shinyjs::toggle(id = "no_match", anim = TRUE, time = 1, animType = "fade"))
    }
  })
  
  output$logoutbtn <- renderUI({
    req(USER$login)
    tags$li(a(icon("fa fa-sign-out"), "Logout", 
              href="javascript:window.location.reload(true)"),
            class = "dropdown", 
            style = "background-color: #eee !important; border: 0;
                    font-weight: bold; margin:5px; padding: 10px;")
  })
  
  output$sidebarpanel <- renderUI({
    if (USER$login == TRUE ){ 
      sidebarMenu(
        menuItem("Main Page", tabName = "main", icon = icon("dashboard")),
        menuItem("Reviews", tabName = "review", icon = icon("widgets")),
        if(USER$permission == "creator") {
          menuItem("Add Restroom", tabName = "addition", icon = icon("widgets"))
        }
      )
    }
  })
  
  output$body <- renderUI({
    if (USER$login == TRUE ) {
      tabItems(
        tabItem(tabName ="main", class = "active",
                fluidRow(
                  box(width = 12, leafletOutput('results'))
                )),
        tabItem(tabName = "addition",
                rest_add_page,
        ),
        tabItem(tabName = "review",
                includeMarkdown("text/rest_viewer.Rmd"))
      )
    }
    else if (CREATE$creating == TRUE) {
      create_user_page
    } else {
      loginpage
    }
  })
  
  output$results <-  renderLeaflet(
    get_map()
  )
  
}