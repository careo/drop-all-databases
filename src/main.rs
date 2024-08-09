use mysql::*;
use mysql::prelude::*;
use std::env;
use std::process;

fn main() {
    // Read MySQL credentials from environment variables
    let user = env::var("MYSQL_USER").unwrap_or_else(|_| "root".to_string());
    let password = env::var("MYSQL_PASSWORD").unwrap_or_else(|_| "".to_string());

    // Create connection options using OptsBuilder
    let opts = OptsBuilder::new()
        .user(Some(user))
        .pass(Some(password))
        .ip_or_hostname(Some("localhost"));

    // Create a connection to the MySQL server
    let pool = match Pool::new(opts) {
        Ok(pool) => pool,
        Err(e) => {
            eprintln!("Error creating pool: {}", e);
            process::exit(1);
        }
    };

    let mut conn = match pool.get_conn() {
        Ok(conn) => conn,
        Err(e) => {
            eprintln!("Error getting connection: {}", e);
            process::exit(1);
        }
    };

    // Define system databases to exclude
    let excluded_databases = ["information_schema", "mysql", "performance_schema", "sys"];

    // Get the list of databases
    let databases: Vec<String> = match conn.query("SHOW DATABASES") {
        Ok(result) => result.into_iter()
            .map(|row: mysql::Row| row.get::<String, &str>("Database").unwrap())
            .filter(|db| !excluded_databases.contains(&db.as_str()))
            .collect(),
        Err(e) => {
            eprintln!("Error querying databases: {}", e);
            process::exit(1);
        }
    };

    // Drop each database one at a time
    for db in databases {
        match conn.query_drop(format!("DROP DATABASE `{}`", db)) {
            Ok(_) => println!("Dropped database: {}", db),
            Err(e) => eprintln!("Error dropping database {}: {}", db, e),
        }
    }

    println!("All non-system databases have been processed.");
}
