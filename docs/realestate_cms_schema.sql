-- Proponowany model danych CMS -> frontend dla strony wybranej inwestycji.

CREATE TABLE IF NOT EXISTS realestate_houses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_realestate INT NOT NULL,
  symbol VARCHAR(32) NOT NULL,
  plot_number VARCHAR(64) NULL,
  area_house DECIMAL(10,2) NULL,
  area_plot DECIMAL(10,2) NULL,
  price DECIMAL(12,2) NULL,
  status_id TINYINT NOT NULL DEFAULT 2 COMMENT '0: wolne, 1: zajęte, 2: rezerwacja',
  hotspot_x DECIMAL(5,2) NULL COMMENT 'pozycja na planie osiedla w %',
  hotspot_y DECIMAL(5,2) NULL COMMENT 'pozycja na planie osiedla w %',
  queue INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_realestate_houses_realestate (id_realestate),
  INDEX idx_realestate_houses_status (status_id)
);

CREATE TABLE IF NOT EXISTS realestate_infrastructure (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_realestate INT NOT NULL,
  name VARCHAR(128) NOT NULL,
  distance_label VARCHAR(64) NOT NULL COMMENT 'np. 350 m / 4 min',
  icon VARCHAR(255) NULL COMMENT 'ścieżka/nazwa pliku ikony',
  queue INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_realestate_infra_realestate (id_realestate)
);

CREATE TABLE IF NOT EXISTS realestate_floorplans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_realestate INT NOT NULL,
  floor_key VARCHAR(32) NOT NULL COMMENT 'parter | pietro | poddasze ...',
  floor_name VARCHAR(64) NOT NULL COMMENT 'etykieta na froncie, np. Parter',
  room_name VARCHAR(128) NOT NULL,
  area DECIMAL(10,2) NULL,
  queue INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_realestate_floorplans_realestate (id_realestate),
  INDEX idx_realestate_floorplans_floor (floor_key)
);

CREATE TABLE IF NOT EXISTS realestate_files (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_realestate INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  file_path VARCHAR(255) NOT NULL COMMENT 'np. /uploads/files/prospekt-osiedla.pdf',
  file_type VARCHAR(16) NULL COMMENT 'pdf/docx/xlsx itp.',
  queue INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_realestate_files_realestate (id_realestate)
);
