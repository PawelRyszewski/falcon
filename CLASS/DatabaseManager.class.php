<?php
class DatabaseManager
{
    private static $isConnected = false;
    private static $connection = null;
    public static function getConnection()
    {
        try {
            if(self::$isConnected and self::$connection) {
                return self::$connection;
            }
            $HOST = getenv("HOST");
            $DB_NAME = getenv("DB_NAME");
            $USERNAME = getenv("USERNAME");
            $PASSWORD = getenv("PASSWORD");
            $pdo = new PDO("mysql:host=$HOST;dbname=$DB_NAME; charset=utf8", $USERNAME, $PASSWORD);
            // $pdo = new PDO('mysql:host=localhost;dbname=weo; charset=utf8', 'root', '');
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $pdo->exec("set names utf8");
            self::$connection = $pdo;
            self::$isConnected = true;
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
        return $pdo;
    }

    //USAGE: DatabaseManager::selectSql("SELECT * FROM products ORDER BY name DESC");
    static public function selectSql($sql)
    {
        $pdo = self::getConnection();

        $stmt = $pdo->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();


        return $result ?: [];
    }

    //USAGE DatabaseManager::selectSqlGroup("SELECT id,name FROM category ORDER BY name");
    //Its nested array by first value
    static public function selectSqlGroup($sql)
    {
        $pdo = self::getConnection();

        $stmt = $pdo->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll(PDO::FETCH_COLUMN | PDO::FETCH_GROUP);


        return $result ?: [];
    }

    //USAGE DatabaseManager::selectSqlCountGroup("SELECT id_gallery, count(*) FROM images GROUP BY id_gallery"));
    static public function selectSqlGroupAndCountRows($sql)
    {
        $pdo = self::getConnection();

        $stmt = $pdo->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);


        return $result ?: [];
    }


    //USAGE DatabaseManager::updateSql("products", array('active'=>$_POST['status']),"id={$id}");
    static public function updateSql($table, $set = array(), $where = '')
    {
        $pdo = self::getConnection();
        $sql = "UPDATE {$table} SET ";

        foreach ($set as $key => $val) {
            $sql .= ' ' . $key . " = :" . $key . ",";
        }
        $sql = rtrim($sql, ',');
        if ($where !== '') {
            $sql .= " WHERE {$where}";
        }
        $stmt = $pdo->prepare($sql);
        foreach ($set as $key => $val) {
            if (is_null($val) || $val === "NULL") {
                $stmt->bindValue(":" . $key, null, PDO::PARAM_NULL);
            } elseif (is_int($val)) {
                $stmt->bindValue(":" . $key, $val, PDO::PARAM_INT);
            } elseif (is_bool($val)) {
                $stmt->bindValue(":" . $key, $val, PDO::PARAM_BOOL);
            } else {
				$stmt->bindValue(":" . $key, $val, PDO::PARAM_STR); 
            }
        }
        $stmt->execute();
    }

    //USAGE: DatabaseManager::deleteSql('products', "id=$id");
    static public function deleteSql($table, $where)
    {
        $pdo = self::getConnection();
        $sql = "DELETE FROM {$table} WHERE {$where}";
        $stmt = $pdo->prepare($sql);
        $stmt->execute();
    }

    //USAGE: DatabaseManager::insertSql("products", array('name'=>$product_name));
    static public function insertSql($table, $set = array(), $duplicateKey = "")
    {

        $pdo = self::getConnection();
        $sql = "INSERT INTO {$table}";
        $value = "(";
        $value2 = "(";
        foreach ($set as $key => $val) {
            $value .= $key . ",";
            $value2 .= ":" . $key . ",";
        }
        $value = rtrim($value, ',');
        $value .= ')';
        $value2 = rtrim($value2, ',');
        $value2 .= ')';
        $sql .= "{$value} VALUES {$value2} {$duplicateKey}";
        $stmt = $pdo->prepare($sql);

		foreach ($set as $key => $val) {
			if (is_null($val) || $val === "NULL") {
				$stmt->bindValue(":$key", null, PDO::PARAM_NULL);
			} elseif (is_bool($val)) {
				$stmt->bindValue(":$key", $val, PDO::PARAM_BOOL);
			} elseif (is_int($val)) {
				$stmt->bindValue(":$key", $val, PDO::PARAM_INT);
			} else {
				$stmt->bindValue(":$key", $val, PDO::PARAM_STR);
			}
		}
        $stmt->execute();
		return $pdo->lastInsertId();
    }

    static public function incrementValue($table, $set, $where)
    {
        $pdo = self::getConnection();
        $sql = "UPDATE {$table} SET {$set} WHERE {$where}";
        $stmt = $pdo->prepare($sql);
        $stmt->execute();
    }
}
