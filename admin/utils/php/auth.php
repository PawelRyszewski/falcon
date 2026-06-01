<?php
function requireRole(string $minRole): void {
    $hier = ['viewer' => 0, 'editor' => 1, 'admin' => 2];
    if (!isset($_SESSION['role']) || $hier[$_SESSION['role']] < $hier[$minRole]) {
        http_response_code(403);
        exit('Access denied');
    }
}
