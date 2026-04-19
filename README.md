# HarryPotter-SQL-Analysis
# Database and Source:
https://mavenanalytics.io/data-playground/harry-potter-movie-scripts

This project uses a Harry Potter movie dialogue dataset.
The data was imported into an Azure SQL Database for analysis.

# Overview

This project presents an analysis of dialogue, characters, locations, and spell usage in the Harry Potter movie series using T-SQL.

The objective is to explore patterns in dialogue distribution and character interactions to better understand storytelling elements across the films.

Brief Description

The dataset contains structured information about movies, characters, dialogue lines, locations, and spells.

This project analyzes dialogue patterns to identify key characters, commonly used locations, and the distribution of magical elements throughout the series. The analysis helps reveal how dialogue contributes to narrative structure and character importance.

# Objectives
Identify characters with the highest number of dialogue lines
Analyze dialogue distribution across movies
Determine the most common locations in the series
Evaluate spell usage by character
Analyze dialogue length and frequency
Support data-driven analysis of storytelling patterns
Tools and Technologies
Azure SQL Database
T-SQL (SQL Server)
Visual Studio Code
DBCode (for visualizations)
GitHub
Key Analysis and Queries

The project includes multiple analytical queries covering:

Dialogue lines per movie
Top characters by dialogue count
Dialogue distribution by movie and character
Most common locations
Average dialogue length by character
Filtering using variables
Subquery-based analysis
Common Table Expression (CTE) analysis
Spell usage by character using a bridge table
View for summarized character insights
Stored procedure for dynamic movie-based analysis

# Full SQL script available here:
SQL/Project_Queries.sql

# Visualizations

The project includes visual representations of key insights:

Dialogue lines per movie
Characters with the most dialogue
Most common locations
Total spells cast per character 
# Project Team
Leidy Fleitas
Brian Bueso
Tyler Kindred
# Notes
The database was exported as a .bacpac file from Azure SQL
A bridge table was created to model the relationship between dialogue and spells
All queries were executed using SQL Server
Conclusion

 This project demonstrates how SQL can be used to analyze structured datasets and extract meaningful insights related to character behavior, dialogue distribution, and storytelling patterns.
