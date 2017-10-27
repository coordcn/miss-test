-- Copyright © 2017 coord.cn. All rights reserved.
-- @author      QianYe(coordcn@163.com)
-- @license     MIT license

local core      = require("miss-core")
local Object    = core.Object
local utils     = core.utils
local deepEqual = utils.deepEqual
local dump      = utils.dump

local Test = Object:extend()

-- @param   name    {string}    name of the test
function Test:constructor(name)
    self.name       = name
    self.count      = 0
    self.pass       = 0
    self.results    = {}
end

-- @param   passed  {boolean}
-- @param   msg     {string}
-- @param   err     {string}
function Test:_test(passed, msg, err)
    self.count = self.count + 1
  
    msg = msg or ""
    local res = {}
    if passed then
        self.pass   = self.pass + 1
        res.passed  = true
        res.msg     = "[Passed] " .. msg
    else
        res.passed  = false
        res.msg     = "[Failed] " .. msg
        res.error   = err
    end
    
    table.insert(self.results, res)   
end

-- @brief   expression == true or not nil
-- @param   expression  {any}
-- @param   msg         {string}
function Test:ok(expression, msg)
    self:_test(expression, msg, "expression is false or nil") 
end

-- @brief   expression == false or nil
-- @param   expression  {any}
-- @param   msg         {string}
function Test:fail(expression, msg)
    self:_test(not expression, msg, "expression is true or not nil") 
end

-- @brief   equal and deep equal for table
-- @param   actual      {any}
-- @param   expected    {any}
-- @param   msg         {string}
function Test:eq(actual, expected, msg)
    local ok, err = utils.deepEqual(actual, expected)
    self:_test(ok, msg, err)
end

-- @brief   not equal and not deep equal for table
-- @param   actual      {any}
-- @param   expected    {any}
-- @param   msg         {string}
function Test:ne(actual, expected, msg)
    local ok, err = utils.deepEqual(actual, expected)
    self:_test(not ok, msg, "expression is equal")
end

-- @brief   one of
-- @param   actual      {any}
-- @param   expected    {object|array}
-- @param   msg         {string}
function Test:in(val, obj, msg)
    local ok = utils.in(val, obj)
    self:_test(ok, msg, "not in")
end

-- @brief   great than
-- @param   actual      {number}
-- @param   expected    {number}
-- @param   msg         {string}
function Test:gt(actual, expected, msg)
    self:_test(actual > expected, msg, "not >")
end

-- @brief   great than or equal to
-- @param   actual      {number}
-- @param   expected    {number}
-- @param   msg         {string}
function Test:ge(actual, expected, msg)
    self:_test(actual >= expected, msg, "not >=")
end

-- @brief   less than
-- @param   actual      {number}
-- @param   expected    {number}
-- @param   msg         {string}
function Test:lt(actual, expected, msg)
    self:_test(actual < expected, msg, "not <")
end

-- @brief   less than or equal to
-- @param   actual      {number}
-- @param   expected    {number}
-- @param   msg         {string}
function Test:le(actual, expected, msg)
    self:_test(actual <= expected, msg, "not <=")
end

-- @brief   test result
-- @return  result  {object}
function Test:result()
    return {
        name    = self.name,
        count   = self.count,
        pass    = self.pass,
        results = self.results,
    }
end

-- @brief   check and dump then result
function Test:done()
    if self.count ~= self.pass then
        error("Test: " .. name .. " failed.\n" .. dump(self:result()))
    end
end

return _M
