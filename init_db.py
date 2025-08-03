#!/usr/bin/env python3
"""
Database initialization script for StockNear backend.
Creates empty SQLite database files with basic schemas if they don't exist.
"""

import sqlite3
import os

def init_database(db_name, schema_sql):
    """Initialize a database with the given schema."""
    print(f"Initializing {db_name}.db...")
    conn = sqlite3.connect(f"{db_name}.db")
    cursor = conn.cursor()
    cursor.execute(schema_sql)
    conn.commit()
    conn.close()
    print(f"✓ {db_name}.db initialized successfully")

def main():
    """Initialize all required databases."""
    
    # Stocks database schema
    stocks_schema = """
    CREATE TABLE IF NOT EXISTS stocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        symbol TEXT UNIQUE NOT NULL,
        name TEXT,
        type TEXT,
        marketCap REAL,
        exchange TEXT,
        exchangeShortName TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    
    # ETFs database schema
    etfs_schema = """
    CREATE TABLE IF NOT EXISTS etfs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        symbol TEXT UNIQUE NOT NULL,
        name TEXT,
        type TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    
    # Indices database schema
    indices_schema = """
    CREATE TABLE IF NOT EXISTS indices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        symbol TEXT UNIQUE NOT NULL,
        name TEXT,
        type TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    
    # Institute database schema
    institute_schema = """
    CREATE TABLE IF NOT EXISTS institutes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        cik TEXT,
        type TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    
    # Crypto database schema
    crypto_schema = """
    CREATE TABLE IF NOT EXISTS cryptos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        symbol TEXT UNIQUE NOT NULL,
        name TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    
    # Initialize all databases
    databases = [
        ("stocks", stocks_schema),
        ("etf", etfs_schema),
        ("index", indices_schema),
        ("institute", institute_schema),
        ("crypto", crypto_schema)
    ]
    
    for db_name, schema in databases:
        init_database(db_name, schema)
    
    print("\n🎉 Database initialization complete!")

if __name__ == "__main__":
    main() 