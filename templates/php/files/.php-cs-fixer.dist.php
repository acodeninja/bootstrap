<?php

$finder = PhpCsFixer\Finder::create()->in([__DIR__ . '/src', __DIR__ . '/tests']);

return (new PhpCsFixer\Config())
    ->setUnsupportedPhpVersionAllowed(true)
    ->setRules(['@PSR12' => true])
    ->setCacheFile('/cache/php-cs-fixer/.php-cs-fixer.cache')
    ->setFinder($finder);
