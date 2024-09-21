#!/bin/bash

# Function to calculate 75% of total system memory for innodb_buffer_pool_size
calculate_innodb_buffer_pool_size() {
    total_memory=$(free -b | awk '/Mem:/ {print $2}')
    buffer_pool_size=$(echo "$total_memory * 0.75" | bc | awk '{print int($1)}')
    echo $buffer_pool_size
}

# Function to set max_connections to a default or a calculated value
calculate_max_connections() {
    max_connections=200  # You can adjust this based on system needs
    echo $max_connections
}

# Function to set query_cache_size to a reasonable default (100MB)
calculate_query_cache_size() {
    query_cache_size=$((100 * 1024 * 1024))  # 100MB in bytes
    echo $query_cache_size
}

# Function to set innodb_io_capacity based on storage type (default: 200)
calculate_innodb_io_capacity() {
    io_capacity=200  # For HDDs or low-end SSDs. Adjust for faster SSDs if necessary
    echo $io_capacity
}

# Function to calculate innodb_log_file_size (default: 512MB)
calculate_innodb_log_file_size() {
    log_file_size=$((512 * 1024 * 1024))  # 512MB in bytes
    echo $log_file_size
}

# Output configurations to apply dynamically (for running config) or to save in config file
generate_mysql_config() {
    innodb_buffer_pool_size=$(calculate_innodb_buffer_pool_size)
    max_connections=$(calculate_max_connections)
    query_cache_size=$(calculate_query_cache_size)
    innodb_io_capacity=$(calculate_innodb_io_capacity)
    innodb_log_file_size=$(calculate_innodb_log_file_size)

    echo "innodb_buffer_pool_size = ${innodb_buffer_pool_size}  # $(($innodb_buffer_pool_size / 1024 / 1024)) MB"
    echo "max_connections = ${max_connections}"
    echo "query_cache_size = ${query_cache_size}  # $(($query_cache_size / 1024 / 1024)) MB"
    echo "innodb_io_capacity = ${innodb_io_capacity}"
    echo "innodb_log_file_size = ${innodb_log_file_size}  # $(($innodb_log_file_size / 1024 / 1024)) MB"
}

# Apply configuration dynamically to MySQL
apply_running_configuration() {
    sudo mysql -e "SET GLOBAL innodb_buffer_pool_size = $(calculate_innodb_buffer_pool_size);"
    sudo mysql -e "SET GLOBAL max_connections = $(calculate_max_connections);"
    sudo mysql -e "SET GLOBAL query_cache_size = $(calculate_query_cache_size);"
    sudo mysql -e "SET GLOBAL innodb_io_capacity = $(calculate_innodb_io_capacity);"
    sudo mysql -e "SET GLOBAL innodb_log_file_size = $(calculate_innodb_log_file_size);"
}

# Optionally write these settings to my.cnf for persistence on restart
write_startup_configuration() {
    config_file="/etc/mysql/my.cnf"

    # Append settings to the MySQL config file
    echo "[mysqld]" | sudo tee -a $config_file
    echo "innodb_buffer_pool_size = $(calculate_innodb_buffer_pool_size)" | sudo tee -a $config_file
    echo "max_connections = $(calculate_max_connections)" | sudo tee -a $config_file
    echo "query_cache_size = $(calculate_query_cache_size)" | sudo tee -a $config_file
    echo "innodb_io_capacity = $(calculate_innodb_io_capacity)" | sudo tee -a $config_file
    echo "innodb_log_file_size = $(calculate_innodb_log_file_size)" | sudo tee -a $config_file
}

# Execute functions
echo "MySQL Configuration based on system resources:"
generate_mysql_config

echo
echo "Applying configuration dynamically to the running MySQL instance..."
apply_running_configuration

echo
echo "Writing configuration to /etc/mysql/my.cnf for persistence on restart..."
write_startup_configuration
