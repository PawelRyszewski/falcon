START TRANSACTION;

CREATE TABLE IF NOT EXISTS investments (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(191) NOT NULL,
  name VARCHAR(255) NOT NULL,
  location VARCHAR(255) NULL,
  description_short TEXT NULL,
  description_long LONGTEXT NULL,
  status VARCHAR(64) NOT NULL DEFAULT 'Planowana',
  cover_image VARCHAR(255) NULL,
  published_at DATETIME NULL,
  is_published TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_investments_slug (slug),
  KEY idx_investments_status (status),
  KEY idx_investments_published (is_published, published_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS investment_units (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  investment_id INT UNSIGNED NOT NULL,
  unit_name VARCHAR(191) NOT NULL,
  unit_number VARCHAR(64) NULL,
  area_m2 DECIMAL(10,2) NULL,
  rooms TINYINT UNSIGNED NULL,
  price DECIMAL(12,2) NULL,
  status VARCHAR(64) NOT NULL DEFAULT 'Rezerwacja',
  floorplan_file VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_investment_units_investment (investment_id),
  KEY idx_investment_units_status (status),
  CONSTRAINT fk_investment_units_investment
    FOREIGN KEY (investment_id) REFERENCES investments(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS investment_files (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  investment_id INT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  file_path VARCHAR(255) NOT NULL,
  file_type VARCHAR(32) NULL,
  published_at DATETIME NULL,
  sort_order INT NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  KEY idx_investment_files_investment (investment_id),
  KEY idx_investment_files_active (is_active),
  CONSTRAINT fk_investment_files_investment
    FOREIGN KEY (investment_id) REFERENCES investments(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS investment_gallery (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  investment_id INT UNSIGNED NOT NULL,
  image_path VARCHAR(255) NOT NULL,
  alt_text VARCHAR(255) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  KEY idx_investment_gallery_investment (investment_id),
  KEY idx_investment_gallery_active (is_active),
  CONSTRAINT fk_investment_gallery_investment
    FOREIGN KEY (investment_id) REFERENCES investments(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS contact_leads (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  investment_id INT UNSIGNED NULL,
  name VARCHAR(191) NOT NULL,
  email VARCHAR(191) NOT NULL,
  phone VARCHAR(64) NULL,
  message TEXT NULL,
  consent_required TINYINT(1) NOT NULL DEFAULT 0,
  consent_marketing TINYINT(1) NOT NULL DEFAULT 0,
  consent_profiling TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  source_url VARCHAR(255) NULL,
  KEY idx_contact_leads_investment (investment_id),
  KEY idx_contact_leads_created_at (created_at),
  CONSTRAINT fk_contact_leads_investment
    FOREIGN KEY (investment_id) REFERENCES investments(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

COMMIT;
